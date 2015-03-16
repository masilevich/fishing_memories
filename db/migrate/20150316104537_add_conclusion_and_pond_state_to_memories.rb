class AddConclusionAndPondStateToMemories < ActiveRecord::Migration
  def change
  	add_column :memories, :conclusion, :text
  	add_column :memories, :pond_state, :string
  end
end
