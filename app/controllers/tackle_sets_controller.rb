class TackleSetsController < ApplicationController
	include Resource

  load_and_authorize_resource

  before_action :set_tackles, only: [:new, :edit]

  private

  def tackle_set_params
  	params.require(:tackle_set).permit(:name, tackle_ids: [])
  end

  def set_tackles
    @tackles = current_user.tackles
  end
end
