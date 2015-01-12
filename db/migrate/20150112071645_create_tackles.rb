class CreateTackles < ActiveRecord::Migration
  def change
    create_table :tackles do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end

    add_index :tackles, [:user_id]
    add_index :tackles, [:name, :user_id ], unique: true
  end
end
