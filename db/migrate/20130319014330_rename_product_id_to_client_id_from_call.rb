class RenameProductIdToClientIdFromCall < ActiveRecord::Migration
  def up
    rename_column :calls, :product_id, :client_id
  end

  def down
    rename_column :calls, :client_id, :product_id
  end
end
