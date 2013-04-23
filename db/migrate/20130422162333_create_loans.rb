class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :loan_id, null: false
      t.decimal :capital, precision: 15, scale: 5
      t.decimal :payment, precision: 15, scale: 5
      t.integer :expired_payments_count
      t.integer :payments_to_expire_count
      t.datetime :approved_at
      t.datetime :delayed_at
      t.datetime :next_payment_expire_at
      t.references :client, index: true
      t.references :user, index: true
      t.references :branch, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :loans, :loan_id, unique: true
    add_index :loans, :delayed_at
  end
end
