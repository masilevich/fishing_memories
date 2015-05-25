class Note < ActiveRecord::Base
	include ResourceWithName

	acts_as_taggable
end
