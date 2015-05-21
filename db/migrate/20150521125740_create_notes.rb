class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.text :text
      t.references :user, index: true

      t.timestamps
    end
  end
end
