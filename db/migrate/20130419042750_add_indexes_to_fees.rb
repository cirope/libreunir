class AddIndexesToFees < ActiveRecord::Migration
  def change
    add_index :fees, :fee_number
    add_index :fees, :loan_id
    add_index :fees, :expiration_date
  end
end
