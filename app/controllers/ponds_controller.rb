class PondsController < ApplicationController
	include Resource
	include CategorizableResource
	
	load_and_authorize_resource

	private

	def pond_params
		params.require(:pond).permit(:name, :category_id)
	end
end
