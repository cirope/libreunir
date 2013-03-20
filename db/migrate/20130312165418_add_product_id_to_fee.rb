class AddProductIdToFee < ActiveRecord::Migration
  def change
    add_column :fees, :product_id, :string
  end
end
