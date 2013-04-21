class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment, null: false
      t.references :client, null: false, index: true
      t.references :user, null: false, index: true

      t.timestamps
    end
  end
end
