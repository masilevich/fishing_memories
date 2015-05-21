class Place < ActiveRecord::Base
	include ResourceWithName

	belongs_to :pond
	has_and_belongs_to_many :memories
	has_one :map, as: :mappable, dependent: :destroy

	scope :without_pond, -> { where(pond_id: nil) }

	def title
		"#{(pond.name + ' - ') if pond.present?}#{name}"
  end

	def self.grouped_options_for_select(ponds)
		[[I18n.t('fishing_memories.all'), self.without_pond.map { |e| [e.name, e.id] }]] + ponds.includes(:places).map { |pond| [pond.name, 
			pond.places.map { |place| [place.name, place.id] }]}
	end

end
