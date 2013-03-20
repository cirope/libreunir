class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.decimal :rate, precision: 23, scale: 8

      t.timestamps
    end
  end
end
