class AddProductIdToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :product_id, :integer
  end
end
