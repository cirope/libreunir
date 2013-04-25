class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.text :description, null: false
      t.datetime :scheduled_at, null: false
      t.references :schedulable, polymorphic: true
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    add_index :schedules, [:schedulable_id, :schedulable_type]
  end
end