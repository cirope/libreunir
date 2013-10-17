class AddStateToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :state, :string, null: false, default: 'current'

    add_index :loans, :state
  end
end
