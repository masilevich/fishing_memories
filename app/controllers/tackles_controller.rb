class TacklesController < ApplicationController
  
	include Resource

  load_and_authorize_resource

  private

  def tackle_params
  	params.require(:tackle).permit(:name)
  end
end
