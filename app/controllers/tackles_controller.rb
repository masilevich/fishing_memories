class TacklesController < ApplicationController
	include Resource
	include CategorizableResource

  load_and_authorize_resource

  private

  def tackle_params
  	params.require(:tackle).permit(:name, :category_id)
  end
end
