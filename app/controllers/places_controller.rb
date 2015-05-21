class PlacesController < ApplicationController
	include Resource
	include GoogleMap
	
	load_and_authorize_resource

	before_action :set_resources, only: [:index]
	before_action :set_ponds, only: [:new, :edit, :index]

	def create
		@resource = resources.build(resource_params)
		if @resource.save
			flash[:notice] = t('fishing_memories.model_created', model: resource_label)
			@resource.map = current_user.maps.create
			redirect_to edit_place_path(@resource)
		else
			flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
			render 'new'
		end
	end

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
