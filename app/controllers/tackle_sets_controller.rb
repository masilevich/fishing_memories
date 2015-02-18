class TackleSetsController < ApplicationController
	include Resource
  include CategorizableResource

  load_and_authorize_resource

  before_action :set_resources
  before_action :set_tackles, only: [:new, :edit, :index]

  private

  def tackle_set_params
  	params.require(:tackle_set).permit(:name, :category_id, tackle_ids: [])
  end

  def set_tackles
    @tackles = current_user.tackles
  end

  def set_resources
    @resources = resources.includes(:tackles, :category)
  end
end
