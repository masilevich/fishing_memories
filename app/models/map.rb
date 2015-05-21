class Map < ActiveRecord::Base
	belongs_to :user

	has_many :points, dependent: :destroy

	belongs_to :mappable, polymorphic: true
end
