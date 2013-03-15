class AddFeeNumberToFee < ActiveRecord::Migration
  def change
    add_column :fees, :fee_number, :integer
  end
end
