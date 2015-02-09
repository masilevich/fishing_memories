CATEGORY_TYPES = %w(PondCategory TackleCategory TackleSetCategory)

shared_context "category helper" do
	
	def scope_name(type)
		type.tableize
	end

	def category_class(type)
		type.constantize
	end

	def category_single_name(type)
		type.underscore
	end
end