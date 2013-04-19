class AddProductIdIndexToClients < ActiveRecord::Migration
  def change
    add_index :clients, :product_id, unique: true
  end
end
