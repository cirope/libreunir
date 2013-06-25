class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :loan, null: false, index: true
      t.references :user, null: false, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
