class AddPaidToToFee < ActiveRecord::Migration
  def change
    add_column :fees, :paid_to, :string
  end
end
