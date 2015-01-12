class TacklesController < ApplicationController
	include Resource

	private

	def tackle_params
		params.require(:tackle).permit(:name)
	end
end
