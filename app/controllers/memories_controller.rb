class MemoriesController < ApplicationController

	include Resource

	def new
    @resource = resources.build()
    @tackles = current_user.tackles
    @ponds = current_user.ponds
  end

	def index 
    @resources = current_user.memories.page(params[:page])
  end

  def edit
    find_resource
    @tackles = current_user.tackles
    @ponds = current_user.ponds
  end

	private

	def memory_params
		params.require(:memory).permit(:occured_at, :description, tackle_ids: [], pond_ids: [])
	end
end
