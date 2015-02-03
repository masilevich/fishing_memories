module Resource
	module Sort
		
		private
		def sort_column
			if params[:q] && params[:q][:s]
				params[:q][:s].split[0] if resource_class.column_names.include?(params[:q][:s].split[0])
			end
		end
		
		def sort_direction
			%w[asc desc].include?(params[:q][:s].split[1]) ?  params[:q][:s].split[1] : "asc"
		end

	end
end