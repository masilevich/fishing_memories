class RenameOccurToOccuredFromMemories < ActiveRecord::Migration
  def change
  	rename_column :memories, :occur_at, :occured_at
  end
end
