class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.references :user
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :tags, :name
    add_index :tags, :user_id
  end
end
