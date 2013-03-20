class RenameClientIdToOrderId < ActiveRecord::Migration
  def up
    rename_column :loans, :client_id, :order_id
  end

  def down
    rename_column :loans, :order_id, :client_id
  end
end
