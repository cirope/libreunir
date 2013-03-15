class AddProductIdToClient < ActiveRecord::Migration
  def change
    add_column :clients, :product_id, :string
  end
end
