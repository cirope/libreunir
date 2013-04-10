class ChangePaymentDateToDate < ActiveRecord::Migration
  def up
    change_column :fees, :payment_date, :date
  end

  def down
    change_column :fees, :payment_date, :datetime
  end
end
