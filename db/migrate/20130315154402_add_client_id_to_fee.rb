class AddClientIdToFee < ActiveRecord::Migration
  def change
    add_column :fees, :client_id, :integer
  end
end
