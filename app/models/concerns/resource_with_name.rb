module ResourceWithName
	extend ActiveSupport::Concern

	included do
		belongs_to :user

		validates :user_id, presence: true
		validates :name, presence: true

		default_scope -> { order('name ASC') }
	end

	def title
		name
	end
end