class RemoveNoteFromFee < ActiveRecord::Migration
  def up
    remove_column :fees, :note
  end

  def down
    add_column :fees, :note, :string
  end
end
