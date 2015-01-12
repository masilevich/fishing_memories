class PondsController < ApplicationController
  include Resource

	private

	def pond_params
		params.require(:pond).permit(:name)
	end
end
