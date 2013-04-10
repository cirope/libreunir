class ChangeExpirationDateToDate < ActiveRecord::Migration
  def up
    change_column :fees, :expiration_date, :date
  end

  def down
    change_column :fees, :expiration_date, :datetime
  end
end
