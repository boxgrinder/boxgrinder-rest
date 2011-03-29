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

require 'base_consumer'

class ImageConsumer < BaseConsumer
  def progress
    if @payload[:event].nil? or @payload[:image_id].nil?
      @log.error "Received progress info is invalid."
      return
    end

    @log.info "Received new '#{@payload[:event]}' event for image '#{@payload[:image_id]}'."

    image = Image.find(@payload[:image_id])

    unless image.events_for_current_state.include?(@payload[:event].to_s[0..-2].to_sym)
      @log.error "Event #{@payload[:event]} is not valid for current image state: #{image.state}."
      return
    end

    if @payload[:event] == :build!
      node = Node.last(:conditions => {:name => @payload[:node]})
      image.node = node unless node.nil?
    end

    image.send(@payload[:event])
  end
end
