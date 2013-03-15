class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :client
      t.string :street
      t.integer :number
      t.integer :floor
      t.string :location
      t.integer :postal_code

      t.timestamps
    end
    add_index :addresses, :client_id
  end
end
