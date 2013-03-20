class AddDescriptionToAdviser < ActiveRecord::Migration
  def change
    add_column :advisers, :description, :string
  end
end
