class AddColumnsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :capital, :decimal, precision: 15, scale: 5
    add_column :payments, :additional, :decimal, precision: 15, scale: 5
  end
end
