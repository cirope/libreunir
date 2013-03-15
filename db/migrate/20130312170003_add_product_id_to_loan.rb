class AddProductIdToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :product_id, :string
  end
end
