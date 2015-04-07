module Resource
	module Naming
		private

		def resource_class
			controller_name.classify.constantize
		end

		def resource_name
			resource_class.model_name.name
		end

		def singular_resource_name
			resource_class.model_name.singular
		end

		def plural_resource_name
			resource_class.model_name.plural
		end

		def resource_label(resource_class = resource_class())
			resource_class.model_name.human count: 1,
			default: resource_class.to_s.gsub('::', ' ').titleize
		end

		def plural_resource_label(resource_class = resource_class(), options = {})
			defaults = {count: PLURAL_MANY_COUNT, default: resource_label.pluralize.titleize}
			resource_class.model_name.human defaults.merge options
		end

		def namespace
      controller_path.split('/').first
    end
		
	end
end