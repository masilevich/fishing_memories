class PlacesController < ApplicationController
	include Resource
	
	load_and_authorize_resource

	before_action :set_ponds, only: [:new, :edit, :index]

	private

	def place_params
		params.require(:place).permit(:name, :pond_id)
	end

	def set_ponds
    @ponds = current_user.ponds
  end

	def set_resources
    @resources = resources.includes(:pond)
  end

end
