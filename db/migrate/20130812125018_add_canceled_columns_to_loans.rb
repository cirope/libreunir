class AddCanceledColumnsToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :canceled_at, :date

    add_index :loans, :canceled_at
  end
end
