class RemoveLoanIdFromFee < ActiveRecord::Migration
  def change
    remove_column :fees, :loan_id, :integer
  end
end
