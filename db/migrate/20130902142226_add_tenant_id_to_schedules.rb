class AddTenantIdToSchedules < ActiveRecord::Migration
  def change
    add_reference :schedules, :tenant, index: true
  end
end
