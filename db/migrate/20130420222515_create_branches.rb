class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :branch_id, null: false
      t.string :name, null: false
      t.string :address

      t.timestamps
    end
    add_index :branches, :branch_id, unique: true
  end
end
