class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.integer :loan_id
      t.decimal :amount, precision: 23, scale: 8
      t.datetime :expiration_date
      t.datetime :payment_date
      t.text :note
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :fees, :loan_id
  end
end
