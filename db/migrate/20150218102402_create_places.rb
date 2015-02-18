class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.integer :user_id
      t.integer :pond_id

      t.timestamps
    end

    add_index :places, [:user_id]
    add_index :places, [:name, :pond_id, :user_id ], unique: true
  end
end
