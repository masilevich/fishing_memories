class MemoriesController < ApplicationController

	include Resource

  load_and_authorize_resource

  before_action :set_tackles, only: [:new, :edit]
  before_action :set_ponds, only: [:new, :edit]

	def new
    @resource = resources.build()
  end

  def edit
  end

	private

	def memory_params
		params.require(:memory).permit(:occured_at, :description, tackle_ids: [], pond_ids: [])
	end

  def set_tackles
    @tackles = current_user.tackles
  end

  def set_ponds
    @ponds = current_user.ponds
  end
end
