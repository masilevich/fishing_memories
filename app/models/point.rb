class Point < ActiveRecord::Base
	belongs_to :map

	acts_as_gmappable :process_geocoding => false
end
