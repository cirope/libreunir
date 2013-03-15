class AddFullAddressToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :full_address, :string
  end
end
