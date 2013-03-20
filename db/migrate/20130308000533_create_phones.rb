class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.references :client
      t.string :number

      t.timestamps
    end
    add_index :phones, :client_id
  end
end
