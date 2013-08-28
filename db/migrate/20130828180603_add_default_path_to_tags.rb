class AddDefaultPathToTags < ActiveRecord::Migration
  def change
    change_column :tags, :path, 'integer[]', array: true, default: '{}'
    add_index :tags, :path, using: 'gin'
  end
end
