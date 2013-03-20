class AddBranchIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :branch_id, :string
  end
end
