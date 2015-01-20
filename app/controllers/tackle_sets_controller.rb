class TackleSetsController < ApplicationController
	include Resource

  load_and_authorize_resource

  before_action :set_tackles, only: [:new, :edit]

	def search_for_name
    @resources = current_user.tackle_sets.select([:id, :name]).
    where("name like :q", q: "%#{params[:q]}%").
                        order('name').page(params[:page]).per(params[:per]) # this is why we need kaminari. of course you could also use limit().offset() instead

    respond_to do |format|
      format.json { render json: {resources: @resources.map { |e| {id: e.id, text: e.name }} }}
    end
  end

  private

  def tackle_set_params
  	params.require(:tackle_set).permit(:name, tackle_ids: [])
  end

  def set_tackles
    @tackles = current_user.tackles
  end
end
