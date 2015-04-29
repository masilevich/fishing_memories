class Pond < ActiveRecord::Base
	include ResourceWithName
	include Categorizable

	has_many :places
	has_and_belongs_to_many :memories
	has_one :map, as: :mappable

end
