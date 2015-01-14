class TacklesController < ApplicationController
	include Resource

	def search_for_name
    @resources = current_user.tackles.select([:id, :name]).
    where("name like :q", q: "%#{params[:q]}%").
                        order('name').page(params[:page]).per(params[:per]) # this is why we need kaminari. of course you could also use limit().offset() instead

    respond_to do |format|
      format.json { render json: {resources: @resources.map { |e| {id: e.id, text: e.name }} }}
    end
  end

  private

  def tackle_params
  	params.require(:tackle).permit(:name)
  end
end
