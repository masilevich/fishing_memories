class CreateMemories < ActiveRecord::Migration
  def change
    create_table :memories do |t|
      t.references :user, index: true
      t.text :description
      t.date :occur_at

      t.timestamps
    end
  end
end
