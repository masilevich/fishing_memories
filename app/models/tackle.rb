class Tackle < ActiveRecord::Base
	include ResourceWithName

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackle_sets

  self.resource_with_only_name_field = true

	def memories_with_tackle_sets_memories
		Memory.where('memories.id IN 
      (
      	?
      )
      OR memories.id IN
      (
        SELECT "memories"."id" FROM "memories" INNER JOIN "memories_tackle_sets" ON "memories"."id" = "memories_tackle_sets"."memory_id" 
         WHERE "memories_tackle_sets"."tackle_set_id" in (?)
      )', memory_ids, tackle_set_ids)
  end
end
