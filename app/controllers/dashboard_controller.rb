class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :load_resource_loans, :load_filters, :load_filter

  def index
    @title = t 'view.dashboard.index_title'

    @filters.sort_by! { |filter| filter.send(@filter, @loans) }.reverse!
  end

  private

  def load_resource_loans
    @loans = current_user.loans
  end

  def load_filters
    @filters = current_user.zones + current_user.tags
  end

  def load_filter
    @filter = params[:filter].present? ? params[:filter] : 'loans_count'
  end
end
