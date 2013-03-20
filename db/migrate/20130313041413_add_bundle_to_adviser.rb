class AddBundleToAdviser < ActiveRecord::Migration
  def change
    add_column :advisers, :bundle, :string
  end
end
