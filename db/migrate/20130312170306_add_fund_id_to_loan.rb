class AddFundIdToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :fund_id, :integer
  end
end
