class AddBundleToUser < ActiveRecord::Migration
  def change
    add_column :users, :bundle, :string
  end
end
