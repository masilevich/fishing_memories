class BrandsController < ApplicationController
	include Resource
	
	load_and_authorize_resource

	private

	def brand_params
		params.require(:brand).permit(:name)
	end
end
