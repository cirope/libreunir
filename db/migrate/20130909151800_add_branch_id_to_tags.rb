class AddBranchIdToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :branch, index: true
  end
end
