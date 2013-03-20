class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.integer :product_id
      t.text :note
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
