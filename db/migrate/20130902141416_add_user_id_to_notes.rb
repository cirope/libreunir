class AddUserIdToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :user, index: true

    Note.all.each { |note| note.update(user_id: note.noteable.user_id) }

    change_column :notes, :user_id, :integer, null: false
  end
end
