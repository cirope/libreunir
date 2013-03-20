class AddResponsibleOfficialIdToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :responsible_official_id, :string
  end
end
