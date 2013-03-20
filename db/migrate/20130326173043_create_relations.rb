class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.string :relation
      t.integer :user_id
      t.integer :relative_id
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
