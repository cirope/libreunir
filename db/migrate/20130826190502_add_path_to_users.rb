class AddPathToUsers < ActiveRecord::Migration
  def change
    add_column :users, :path, :integer, array: true, default: []
    add_index  :users, :path, using: 'gin'
  end
end
