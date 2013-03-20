class DashboardController < ApplicationController
  before_filter :authenticate_user!, :parameters, :set_dates

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def index
    @title = t 'view.dashboard.index_title'
    @expired = Fee.where('expiration_date BETWEEN ? AND ?', Date.today.at_beginning_of_month, Date.today-1).last(30)
    @close_to_expire = Fee.where('expiration_date BETWEEN ? AND ?', @date.start, @date.end).last(30)
    @close_to_expire = @close_to_expire-@expired

    respond_to do |format|
      format.js
      format.html # index.html.erb
    end
  end

  def expired
    @fees = Fee.where('expiration_date BETWEEN ? AND ?', Date.today.at_beginning_of_month, @date.end).filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  def expiring_info
    @fee = Fee.find(params[:id])
  end

  def close_to_expire
    @fees = Fee.where('expiration_date BETWEEN ? AND ?', @date.start, @date.end).filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  private

  def parameters
    params.permit!
  end

  def set_dates
    @date = DateRange.new(params[:date_range])
  end
end
