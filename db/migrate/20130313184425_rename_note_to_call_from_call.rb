class RenameNoteToCallFromCall < ActiveRecord::Migration
  def up
    rename_column :calls, :note, :call
  end

  def down
    rename_column :calls, :call, :note
  end
end
