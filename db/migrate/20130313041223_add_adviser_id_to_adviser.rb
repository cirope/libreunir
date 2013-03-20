class AddAdviserIdToAdviser < ActiveRecord::Migration
  def change
    add_column :advisers, :adviser_id, :string
  end
end
