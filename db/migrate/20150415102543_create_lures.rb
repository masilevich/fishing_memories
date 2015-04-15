class CreateLures < ActiveRecord::Migration
  def change
    create_table :lures do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
  end
end
