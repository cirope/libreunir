class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :loan_id, null: false
      t.datetime :approved
      t.decimal :capital
      t.decimal :payment
      t.preferences :branch
      t.preferences :user

      t.timestamps
    end
  end
end
