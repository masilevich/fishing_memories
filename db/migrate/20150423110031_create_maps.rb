class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.integer :mappable_id
      t.string  :mappable_type
      t.timestamps
    end
 
    add_index :maps, :mappable_id
  end
end
