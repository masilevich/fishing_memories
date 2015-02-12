class AddWeatherToMemories < ActiveRecord::Migration
  def change
  	add_column :memories, :weather, :string
  end
end
