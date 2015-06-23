class LuresController < ApplicationController
	include Resource
	include CategorizableResource
	include Brandable
	
	load_and_authorize_resource

	before_action :set_resources, only: [:index]

	def index
		@resources ||= resources
		@q = @resources.ransack(params[:q])
		if params[:q]
			@resources = @q.result
			@resources = Kaminari.paginate_array(@resources.to_a.uniq)
		end

		respond_to do |format|
			format.html { @resources = @resources.page(params[:page]) }
			format.json { render json: @resources.sort_by(&:title) }
		end
	end

	private

	def lure_params
		params.require(:lure).permit(:name, :category_id, :brand_id)
	end

	def set_resources
		@resources = resources.includes(:brand)
	end

end
