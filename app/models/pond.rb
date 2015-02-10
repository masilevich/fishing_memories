class Pond < ActiveRecord::Base
	include ResourceWithName
	include Categorizable

	has_and_belongs_to_many :memories

end
