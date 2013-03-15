class RemoveClientIdFromAddress < ActiveRecord::Migration
  def up
    remove_column :addresses, :client_id
  end

  def down
    add_column :addresses, :client_id, :integer
  end
end
