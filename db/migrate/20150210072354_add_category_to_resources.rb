class AddCategoryToResources < ActiveRecord::Migration
  def change
  	add_column :tackles, :category_id, :integer
  	add_column :tackle_sets, :category_id, :integer
  	add_column :ponds, :category_id, :integer
  end
end
