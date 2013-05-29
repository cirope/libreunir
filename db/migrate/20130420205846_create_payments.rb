class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :number, null: false
      t.integer :days_overdue
      t.datetime :expired_at, null: false
      t.datetime :paid_at
      t.decimal :amount_paid, precision: 15, scale: 5
      t.decimal :total_paid, precision: 15, scale: 5
      t.references :loan, null: false, index: true
      t.references :user, index: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :payments, :number
    add_index :payments, :expired_at
  end
end
