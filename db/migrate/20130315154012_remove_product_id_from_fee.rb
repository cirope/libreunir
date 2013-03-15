class RemoveProductIdFromFee < ActiveRecord::Migration
  def up
    remove_column :fees, :product_id
  end

  def down
    add_column :fees, :product_id, :string
  end
end
