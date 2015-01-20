class CreateJoinTableTackleTackleSet < ActiveRecord::Migration
  def change
    create_join_table :tackles, :tackle_sets do |t|
      # t.index [:tackle_id, :r_id]
      # t.index [:r_id, :tackle_id]
    end
  end
end
