module GoogleMap
	extend ActiveSupport::Concern

	included do
    before_action :set_points, only: [:show, :edit]
  end

  private

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