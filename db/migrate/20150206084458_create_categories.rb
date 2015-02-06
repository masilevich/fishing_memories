class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
			t.string :name
      t.integer :user_id
      t.string :type
      t.timestamps
    end

    add_index :categories, [:user_id]
    add_index :categories, [:name, :type, :user_id ], unique: true
  end
end
