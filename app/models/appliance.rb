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

class Appliance < ActiveRecord::Base
  include ActiveRecord::Transitions

  state_machine do
    state :new
    state :ready
    state :error

    event :prepare do
      transitions :to => :ready, :from => [:new]
    end

    event :error do
      transitions :to => :error, :from => [:new]
    end
  end

  has_many :images
  validates_presence_of :name, :definition
  validates_uniqueness_of :name
#
#  def self.definitions
#    @@definitions = {}
#    Appliance.all(:select => "name, status, config") { |appliance| @@definitions[appliance.name] = appliance.config.definition }
#
#    @@definitions
#  end
#
#  def self.add_definition(name, definition)
#    @@definitions[name] = definition
#  end
end