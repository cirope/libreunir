class AddClientIdToFee < ActiveRecord::Migration
  def change
    add_column :fees, :client_id, :string
  end
end
