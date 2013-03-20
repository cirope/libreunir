class AddNumberOfFeesToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :number_of_fees, :integer
  end
end
