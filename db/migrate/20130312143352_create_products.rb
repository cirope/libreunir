class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_id
      t.integer :branch_id
      t.datetime :delay_date
      t.decimal :expired_debt, precision: 23, scale: 8
      t.decimal :total_debt, precision: 23, scale: 8
      t.integer :expired_fees
      t.integer :fees_to_expire

      t.timestamps
    end
    add_index :products, :branch_id
  end
end
