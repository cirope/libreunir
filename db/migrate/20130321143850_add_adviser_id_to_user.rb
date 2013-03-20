class AddAdviserIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :adviser_id, :string
  end
end
