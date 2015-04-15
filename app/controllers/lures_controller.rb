class LuresController < ApplicationController
	include Resource
	include CategorizableResource
	
	load_and_authorize_resource

	private

	def lure_params
		params.require(:lure).permit(:name, :category_id)
	end

end
