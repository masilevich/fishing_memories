class CreateTackleSets < ActiveRecord::Migration
  def change
    create_table :tackle_sets do |t|
    	t.string :name
      t.integer :user_id
      t.timestamps
    end

    add_index :tackle_sets, [:user_id]
    add_index :tackle_sets, [:name, :user_id ], unique: true
  end
end
