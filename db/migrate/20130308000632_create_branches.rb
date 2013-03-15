class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.references :zone
      t.string :name

      t.timestamps
    end
    add_index :branches, :zone_id
  end
end
