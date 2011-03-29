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

class AppliancesController < ApplicationController
  respond_to :html, :xml, :json

  def index
    respond_with(@appliances = Appliance.all)
  end

  def show
    respond_with(@appliance = Appliance.find(params[:id]))
  end

  def destroy
    @appliance = Appliance.find(params[:id])

    if @appliance.destroy
      flash[:notice] = "Appliance was successfully deleted."
    else
      flash[:error] = "Appliance wasn't deleted. Please make sure there are no images depending on this appliance."
    end

    respond_with(@appliance)
  end

  def create
    @appliance = Appliance.new(:definition => params[:definition])
    flash[:notice] = 'Appliance was successfully created.' if @appliance.save
    respond_with(@appliance)
  end
end
