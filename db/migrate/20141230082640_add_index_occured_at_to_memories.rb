class AddIndexOccuredAtToMemories < ActiveRecord::Migration
  def change
  	add_index :memories, [:user_id, :occured_at ]
  end
end
