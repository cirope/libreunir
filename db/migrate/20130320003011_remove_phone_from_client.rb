class RemovePhoneFromClient < ActiveRecord::Migration
  def change
    remove_column :clients, :phone, :string
  end
end
