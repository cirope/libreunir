class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :product_id
      t.text :note

      t.timestamps
    end
  end
end
