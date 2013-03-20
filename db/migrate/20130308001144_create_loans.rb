class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :client_id
      t.integer :adviser_id
      t.decimal :amount, precision: 23, scale: 8
      t.datetime :grant_date
      t.datetime :expiration_date
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :loans, :client_id
    add_index :loans, :adviser_id
  end
end
