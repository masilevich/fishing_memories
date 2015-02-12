module TypeableCategory
	extend ActiveSupport::Concern

	included do
		has_many :"#{related_resources_plural_name}", foreign_key: "category_id"

		define_singleton_method "categories_for_#{related_resources_plural_name}" do |collection|
			self.joins(:"#{related_resources_plural_name}").where(:"#{related_resources_plural_name}" => {id: collection.pluck(:id)}).uniq
		end

	end

	def related_resources
		send(related_resources_plural_name)
	end

	def related_resources_plural_name
		type.sub("Category","").tableize
	end

	def related_resources_single_name
		type.sub("Category","").underscore
	end

	module ClassMethods
		def related_resources_plural_name
			name.sub("Category","").tableize
		end

		def related_resources_single_name
			name.sub("Category","").underscore
		end
	end
end