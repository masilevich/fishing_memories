class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :name
      t.string :description
      t.float :latitude
      t.float :longitude
      t.integer :map_id
      t.timestamps
    end
  end
end
