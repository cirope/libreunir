class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :product_id, null: false
      t.datetime :delay_date
      t.decimal :expired_debt, precision: 20, scale: 5
      t.decimal :total_debt, precision: 20, scale: 5
      t.decimal :debt_to_expire, precision: 20, scale: 5
      t.integer :delay_maximum
      t.references :client, index: true
      t.references :branch, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :products, :product_id, unique: true
  end
end
