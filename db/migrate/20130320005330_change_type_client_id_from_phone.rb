class ChangeTypeClientIdFromPhone < ActiveRecord::Migration
  def up
    change_column :phones, :client_id, :string
  end

  def down
    change_column :phones, :client_id, :integer
  end
end
