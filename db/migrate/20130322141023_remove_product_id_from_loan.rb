class RemoveProductIdFromLoan < ActiveRecord::Migration
  def change
    remove_column :loans, :product_id, :string
  end
end
