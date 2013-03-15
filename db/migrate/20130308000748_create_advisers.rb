class CreateAdvisers < ActiveRecord::Migration
  def change
    create_table :advisers do |t|
      t.string :name
      t.string :lastname
      t.string :identification
      t.references :branch

      t.timestamps
    end
    add_index :advisers, :branch_id
  end
end
