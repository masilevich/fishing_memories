class Pond < ActiveRecord::Base
	include ResourceWithName

	has_and_belongs_to_many :memories

	self.resource_with_only_name_field = true
end
