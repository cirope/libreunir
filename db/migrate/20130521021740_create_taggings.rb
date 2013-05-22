class CreateTaggings < ActiveRecord::Migration
  def change
    create_table :taggings do |t|
      t.references :tag, null: false, index: true
      t.references :taggable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :taggings, [:taggable_id, :taggable_type]
  end
end
