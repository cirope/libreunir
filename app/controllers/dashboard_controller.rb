class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource_loans, :load_zones, :load_data

  def index
    @title = t 'view.dashboard.index_title'
  end

  private

  def load_resource_loans
    @loans = current_user.loans
  end

  def load_zones
    @zones = current_user.zones + current_user.tags
  end

  def load_data
    @data_container = {}

    Loan::FILTERS.keys.each do |filter|
      data = {}

      @zones.each { |zone| data[zone] = zone.send(filter, @loans) }

      @data_container[filter] = sort_data(data).first(5)
    end
  end

  def sort_data(data)
    data.sort_by { |k,v| v }.reverse!
  end
end
