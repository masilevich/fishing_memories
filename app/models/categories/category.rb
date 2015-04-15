class Category < ActiveRecord::Base
	include ResourceWithName

   def self.types
      %w(PondCategory TackleCategory TackleSetCategory LureCategory)
   end

	self.types.each do |s|
    scope s.tableize, -> {where(type: s)} 
  end


end
