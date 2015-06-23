class Tackle < ActiveRecord::Base
	include ResourceWithName
  include Categorizable

	has_and_belongs_to_many :memories
	has_and_belongs_to_many :tackle_sets
  belongs_to :brand

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

  def title
    brand ? "#{brand.name} #{name}" : name
  end
end
