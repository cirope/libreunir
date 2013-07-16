class AddColumnsToZones < ActiveRecord::Migration
  def change
    rename_column :zones, :name, :zone_id
    add_column :zones, :name, :string
    add_reference :zones, :branch, index: true

    add_index :zones, :name
  end
end
