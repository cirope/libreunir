class RenameClientIdToLoanIdFromFees < ActiveRecord::Migration
  def up
    rename_column :fees, :client_id, :loan_id
  end

  def down
    rename_column :fees, :loan_id, :client_id
  end
end
