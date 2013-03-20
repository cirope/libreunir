class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :client_id
      t.string :street
      t.integer :number
      t.integer :floor
      t.string :location
      t.integer :postal_code
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :addresses, :client_id
  end
end
