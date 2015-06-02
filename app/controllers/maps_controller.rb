class MapsController < ApplicationController

	load_and_authorize_resource
	
	def show
		@map = find_mappable.map
		@points = @map.try(:points)
		@map_id = @map.id
		if @points.try(:any?)
	    @json = @points.to_gmaps4rails do |point, marker|
	      @point = point
	      marker.infowindow render_to_string('points/show', :layout => false)    
	      marker.json({ :id => @point.id })
	    end
  	end
	end

	def find_mappable  
	  params.each do |name, value|  
	    if name =~ /(.+)_id$/  
	      return $1.classify.constantize.find(value)  
	    end  
	  end  
	  nil  
	end  
end
