module Resource
	module Sort
		
		private
		def sort_column
			params[:sort] if resource_class.column_names.include?(params[:sort])
		end
		
		def sort_direction
			%w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
		end

	end
end