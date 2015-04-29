class Map < ActiveRecord::Base
	has_many :points, dependent: :destroy

	belongs_to :mappable, polymorphic: true
end
