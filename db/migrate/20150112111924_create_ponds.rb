class CreatePonds < ActiveRecord::Migration
  def change
    create_table :ponds do |t|
    	t.string :name
      t.integer :user_id
      t.timestamps
    end

    add_index :ponds, [:user_id]
    add_index :ponds, [:name, :user_id ], unique: true
  end
end
