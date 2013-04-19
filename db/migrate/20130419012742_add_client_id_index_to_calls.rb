class AddClientIdIndexToCalls < ActiveRecord::Migration
  def change
    add_index :calls, :client_id
  end
end
