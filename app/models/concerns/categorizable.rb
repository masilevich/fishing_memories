module Categorizable
	extend ActiveSupport::Concern

	included do
		belongs_to :category, class_name: "#{name}Category", foreign_key: "category_id"
		accepts_nested_attributes_for :category,
		:reject_if => proc { |attrs|
			attrs['name'].blank? &&
			attrs['category_id'].blank?
		}
		scope :without_category, -> { where(category_id: nil) }
		scope :with_category, ->(category) {where(category_id: category.id)}

		def self.grouped_by_category_options_for_select(categories, option_value_method)
			[[I18n.t('fishing_memories.all'), self.without_category.map { |e| [e.name, e.id] }]] + 
			  categories.includes(categories.related_resources_plural_name.to_sym).map { |category| [category.name, 
				category.related_resources.map { |resource| [resource.send(option_value_method), resource.id] }]}
		end
	end

end
