class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone, null: false
      t.string :carrier
      t.references :client, null: false, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
