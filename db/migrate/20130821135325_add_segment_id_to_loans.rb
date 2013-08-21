class AddSegmentIdToLoans < ActiveRecord::Migration
  def change
    add_reference :loans, :segment, index: true
  end
end
