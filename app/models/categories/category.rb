class Category < ActiveRecord::Base
	include ResourceWithName

	self.resource_with_only_name_field = true

   def self.types
      %w(PondCategory TackleCategory TackleSetCategory)
   end

	self.types.each do |s|
    scope s.tableize, -> {where(type: s)} 
  end


end
