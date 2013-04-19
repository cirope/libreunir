class AddClientIdIndexToAddresses < ActiveRecord::Migration
  def change
    add_index :addresses, :client_id
  end
end
