class AddAmountToFinanceToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :amount_to_finance, :decimal
  end
end
