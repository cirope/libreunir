class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
