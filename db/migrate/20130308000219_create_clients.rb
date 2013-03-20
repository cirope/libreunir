class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :identification
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
  end
end
