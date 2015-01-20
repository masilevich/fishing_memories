class Tackle < ActiveRecord::Base
	include ResourceWithName

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackle_sets
end
