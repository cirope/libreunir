class ChangeClientIdFromLoan < ActiveRecord::Migration
  def up
    change_column :loans, :client_id, :string
  end

  def down
    change_column :loans, :client_id, :integer
  end
end
