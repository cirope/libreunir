class RenameResponsibleOfficialIdToUserId < ActiveRecord::Migration
  def up
    rename_column :orders, :responsible_official_id, :user_id
  end

  def down
    rename_column :orders, :user_id, :responsible_official_id
  end
end
