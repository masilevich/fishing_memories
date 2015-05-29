class PondsController < ApplicationController
	include Resource
	include CategorizableResource
	include GoogleMap
	
	load_and_authorize_resource

	before_action :set_resources

	def create
		@resource = resources.build(resource_params)
		if @resource.save
			flash[:notice] = t('fishing_memories.model_created', model: resource_label)
			@resource.map = current_user.maps.create
			redirect_to edit_pond_path(@resource)
		else
			flash.now[:alert] = t('fishing_memories.model_not_created', model: resource_label)
			render 'new'
		end
	end

	private

	def pond_params
		params.require(:pond).permit(:name, :category_id)
	end

	def set_resources
    @resources = resources.includes(:places)
  end

end
