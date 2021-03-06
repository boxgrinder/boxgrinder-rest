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
  has_many :images

  before_validation :set_name
  before_destroy { |appliance| appliance.images.size == 0 }

  validates :name, :presence => true, :uniqueness => true
  validates :definition, :presence => true

  validate :appliance_definition_valid?

  private

  def set_name
    self.name = YAML.load(self.definition)['name'] if self.new_record?
  end

  def appliance_definition_valid?
    # TODO validate with Kwalify, should be done in boxgrinder-core
  end
end