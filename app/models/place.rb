class Place < ActiveRecord::Base
	include ResourceWithName

	belongs_to :pond
	has_and_belongs_to_many :memories

end
