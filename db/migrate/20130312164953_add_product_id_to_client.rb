class AddProductIdToClient < ActiveRecord::Migration
  def change
    add_column :clients, :product_id, :integer
  end
end
