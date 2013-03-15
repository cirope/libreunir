class AddCapitalToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :capital, :decimal
  end
end
