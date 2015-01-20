class TackleSet < ActiveRecord::Base

	include ResourceWithName

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackles

	def title
  	"#{name}#{(' (' + tackles.pluck(:name).join(' + ') + ')') if tackles.any?}"
  end

end
