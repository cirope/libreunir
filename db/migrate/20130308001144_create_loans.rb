class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :client
      t.references :adviser
      t.decimal :amount, precision: 23, scale: 8
      t.datetime :grant_date
      t.datetime :expiration_date

      t.timestamps
    end
    add_index :loans, :client_id
    add_index :loans, :adviser_id
  end
end
