class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.references :user, index: true
      t.timestamps
    end

    add_column :lures, :brand_id, :integer
    add_column :tackles, :brand_id, :integer
  end
end
