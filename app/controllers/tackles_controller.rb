class TacklesController < ApplicationController
	include Resource
	include CategorizableResource
	include Brandable

  load_and_authorize_resource

  before_action :set_resources, only: [:index]

  private

  def tackle_params
  	params.require(:tackle).permit(:name, :category_id, :brand_id)
  end

  def set_resources
		@resources = resources.includes(:brand)
	end
end
