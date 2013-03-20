class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.string :adviser_id
      t.string :segment_id
      t.integer :branch_id
      t.string :zone_id
      t.string :assigned_adviser_id
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :orders, :order_id
    add_index :orders, :adviser_id
    add_index :orders, :segment_id
    add_index :orders, :branch_id
    add_index :orders, :zone_id
  end
end
