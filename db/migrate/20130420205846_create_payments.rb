class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :number, null: false
      t.datetime :expiration, null: false
      t.datetime :payment_date
      t.decimal :amount_paid, precision: 15, scale: 10
      t.decimal :total, precision: 15, scale: 10
      t.references :product, null: false, index: true
      t.references :user, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :payments, :number
    add_index :payments, :expiration
  end
end
