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

class Node < ActiveRecord::Base
  include ActiveRecord::Transitions

  state_machine do
    state :inactive
    state :active
    state :error

    event :toggle do
      transitions :to => :active, :from => [:inactive]
      transitions :to => :inactive, :from => [:active]
    end

    event :error do
      transitions :to => :error, :from => [:active, :inactive]
    end
  end

  validates_presence_of :name, :address
end
