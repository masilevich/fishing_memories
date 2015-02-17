class TackleSet < ActiveRecord::Base
	include ResourceWithName
	include Categorizable

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackles

	def title
		"#{name}#{(' (' + tackles.map(&:name).join(' + ') + ')') if tackles.present?}"
  end

end
