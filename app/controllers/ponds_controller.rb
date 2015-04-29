class PondsController < ApplicationController
	include Resource
	include CategorizableResource
	
	load_and_authorize_resource

	before_action :set_points, only: [:show, :edit]

	private

	def pond_params
		params.require(:pond).permit(:name, :category_id)
	end

	def set_points
		@points = @resource.map.try(:points)
		@map_id = @resource.map.try(:id)
		if @points.try(:any?)
	    @json = @points.to_gmaps4rails do |point, marker|
	      @point = point
	      marker.infowindow render_to_string('points/show', :layout => false)    
	      marker.json({ :id => @point.id })
	    end
  	end

	end
end
