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

class NodeConsumer < BaseConsumer
  def register
    node_config = @payload[:node]

    @log.info "Registering node '#{node_config[:name]}'..."

    node = Node.last(:conditions => {:name => node_config[:name]})

    unless node.nil?
      @log.info "Node '#{node.name}' is already registered, status: '#{node.state}'."

      unless node.current_state == :active
        @log.info "Activating node..."
        node.activate!
      end
    else
      node = Node.new(node_config)
      node.save!
    end

    @log.debug "Confirming '#{node_config[:name]}' registration..."

    confirm(node, :register)

    @log.info "Node registered."
  end

  def unregister
    node_config = @payload[:node]

    @log.info "Unregistering node '#{node_config[:name]}'."

    node = Node.last(:conditions => {:name => node_config[:name]})
    unless node.nil?
      node.deactivate!

      @log.debug "Confirming '#{node_config[:name]}' unregistration..."

      confirm(node, :unregister)

      @log.info "Node '#{node_config[:name]}' unregistered."
    else
      @log.debug "Node '#{node_config[:name]}' couldn't be found. Silently ignoring..."
    end
  end

  def confirm(node, operation)
    TorqueBox::Messaging::Topic.new('/topics/boxgrinder_rest/node').publish(
        'ok',
        :properties => {
            :node => node.name,
            :operation => operation
        })
  end
end
