class CreateMemoriesTackles < ActiveRecord::Migration
  def change
    create_table :memories_tackles, :id => false do |t|
    	t.references :memory
      t.references :tackle
    end
  end
end
