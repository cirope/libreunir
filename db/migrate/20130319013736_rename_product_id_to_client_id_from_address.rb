class RenameProductIdToClientIdFromAddress < ActiveRecord::Migration
  def up
    rename_column :addresses, :product_id, :client_id
  end

  def down
    rename_column :addresses, :client_id, :product_id
  end
end
