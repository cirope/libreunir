class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :lastname, null: false
      t.string :identification, null: false
      t.string :address
      t.string :phone
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :clients, :name
    add_index :clients, :lastname
    add_index :clients, :identification, unique: true
  end
end
