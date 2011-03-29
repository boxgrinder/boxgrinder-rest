#
# Copyright 2010 Red Hat, Inc.
#
# This is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 3 of
# the License, or (at your option) any later version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this software; if not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Fleventoor, Boston, MA
# 02110-1301 USA, or see the FSF site: http://www.fsf.org.

class Image < ActiveRecord::Base
  include ActiveRecord::Transitions

  state_machine do
    state :new
    state :queued
    state :building
    state :built
    state :delivering
    state :delivered
    state :error

    event :enqueue do
      transitions :to => :queued, :from => [:new]
    end

    event :build do
      transitions :to => :building, :from => [:queued]
    end

    event :built do
      transitions :to => :built, :from => [:building]
    end

    event :error do
      transitions :to => :error, :from => [:new, :building]
    end
  end

  validates_presence_of :appliance
  belongs_to :appliance
  belongs_to :node
  has_many :images, :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Image"

  after_create :enqueue_build_task

  def events_for_current_state
    Image.state_machines[:default].events_for(self.current_state)
  end

  private

  def enqueue_build_task
#    appliance = YAML.load(self.appliance.definition)

    TorqueBox::Messaging::Topic.new('/queues/boxgrinder_rest/image').publish(
        {
            :action => :build,
            :definition => self.appliance.definition,
            :image_id => self.id
        },
        :properties => {
            :arch => self.arch
            #            :os_name => appliance['os']['name'],
            #            :os_version => appliance['os']['version']
        }
    )

    self.enqueue!
  end
end

