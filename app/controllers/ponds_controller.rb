class PondsController < ApplicationController

  include Resource

  load_and_authorize_resource

	private

	def pond_params
		params.require(:pond).permit(:name)
	end
end
