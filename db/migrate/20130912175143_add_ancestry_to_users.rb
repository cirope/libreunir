class AddAncestryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ancestry, :string
    add_index :users, :ancestry

    remove_column :users, :path
  end
end
