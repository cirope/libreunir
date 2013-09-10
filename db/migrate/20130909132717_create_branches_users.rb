class CreateBranchesUsers < ActiveRecord::Migration
  def change
    create_table :branches_users do |t|
      t.references :branch, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
