class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :segment_id, null: false
      t.string :description
      t.string :short_description

      t.timestamps
    end
    add_index :segments, :segment_id, unique: true
  end
end
