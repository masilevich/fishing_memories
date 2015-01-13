class CreateMemoriesPonds < ActiveRecord::Migration
  def change
    create_table :memories_ponds, :id => false do |t|
    	t.references :memory
      t.references :pond
    end
  end
end
