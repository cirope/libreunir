class AddTotalAmountToFee < ActiveRecord::Migration
  def change
    add_column :fees, :total_amount, :decimal
  end
end
