class MemoriesController < ApplicationController

	include Resource

	private

	def memory_params
		params.require(:memory).permit(:occured_at, :description)
	end
end
