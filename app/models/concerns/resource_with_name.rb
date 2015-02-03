module ResourceWithName
	extend ActiveSupport::Concern

	included do
		class_attribute :resource_with_only_name_field
		
		belongs_to :user

		validates :user_id, presence: true
		validates :name, presence: true

		default_scope -> { order('name ASC') }
	end

	def title
		name
	end
end