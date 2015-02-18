class CreateJoinTableMemoryPlace < ActiveRecord::Migration
  def change
  	create_join_table :memories, :places do |t|
  	end
  end
end
