class AddDebtorToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :debtor, :boolean, null: false, default: false
    add_index :loans, :debtor
  end
end
