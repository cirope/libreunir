class RenameNumberToPhoneFromPhone < ActiveRecord::Migration
  def up
    rename_column :phones, :number, :phone
  end

  def down
    rename_column :phones, :phone, :number
  end
end
