class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :note, null: false
      t.references :noteable, null: false, polymorphic: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :notes, [:noteable_id, :noteable_type]
  end
end
