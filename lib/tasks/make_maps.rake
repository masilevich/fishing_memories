namespace :db do
  desc "make maps for ponds and places without map"

  task make_maps: :environment do
  	mappable_classes = [Pond, Place]
  	mappable_classes.each do |mappable_class|  
  		mappable_class.all.each do |mappable_object|
	    	unless mappable_object.map
	    		mappable_object.map = Map.create(user_id: mappable_object.user_id)
	    	end
	    end
  	end
    
  end

end