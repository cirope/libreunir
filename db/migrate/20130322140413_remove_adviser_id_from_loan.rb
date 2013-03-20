class RemoveAdviserIdFromLoan < ActiveRecord::Migration
  def change
    remove_column :loans, :adviser_id, :string
  end
end
