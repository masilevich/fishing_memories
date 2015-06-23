class Brand < ActiveRecord::Base
	include ResourceWithName
	
	has_many :lures
	has_many :tackles
end
