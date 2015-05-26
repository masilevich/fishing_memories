class Note < ActiveRecord::Base
	default_scope -> { order('updated_at DESC') }

	include ResourceWithName

	acts_as_taggable
end
