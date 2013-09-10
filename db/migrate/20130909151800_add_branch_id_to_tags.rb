class AddBranchIdToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :branch, index: true, null: false, default: 0
  end
end
