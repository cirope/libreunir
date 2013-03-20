class AddProductIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :product_id, :string
  end
end
