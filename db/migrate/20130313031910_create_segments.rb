class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :segment_id
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
