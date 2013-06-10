class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.integer :branch_id, null: false
      t.string :name, null: false
      t.string :address
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end
    add_index :branches, :branch_id, unique: true
  end
end
