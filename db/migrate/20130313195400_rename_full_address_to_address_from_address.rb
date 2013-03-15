class RenameFullAddressToAddressFromAddress < ActiveRecord::Migration
  def up
    rename_column :addresses, :full_address, :address
  end

  def down
    rename_column :addresses, :address, :full_address
  end
end
