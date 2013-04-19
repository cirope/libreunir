class AddSegmentIdIndexToSegments < ActiveRecord::Migration
  def change
    add_index :segments, :segment_id, unique: true
  end
end
