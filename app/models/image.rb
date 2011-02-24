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
    state :building
    state :built
    state :delivering
    state :delivered
    state :error

    event :build do
      transitions :to => :building, :from => [:new]
    end

    event :built do
      transitions :to => :building, :from => [:building]
    end

    event :error do
      transitions :to => :error, :from => [:new, :building]
    end
  end

  validates_presence_of :appliance, :node
  belongs_to :appliance
  belongs_to :node
  has_many :images, :foreign_key => "parent_id", :dependent => :destroy
  belongs_to :parent, :class_name => "Image"
end

