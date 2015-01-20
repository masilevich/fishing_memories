class CreateJoinTableMemoryTackleSet < ActiveRecord::Migration
  def change
    create_join_table :memories, :tackle_sets do |t|
      # t.index [:memory_id, :tackle_set_id]
      # t.index [:tackle_set_id, :memory_id]
    end
  end
end
