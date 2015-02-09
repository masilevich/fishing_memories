class CategoriesController < ApplicationController

	include Resource

  load_and_authorize_resource

	before_action :set_type

	private

	def resource_class
		type.constantize
	end

	def set_type 
		@type = type 
	end

	def type 
		Category.types.include?(params[:type]) ? params[:type] : "Category"
	end

	def category_params
		params.require(:"#{type.underscore}").permit(:name, :type)
	end

	Category.types.each do |type|
		define_method(:"#{type.underscore}_params") { category_params }
  end

end
