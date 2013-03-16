class DashboardController < ApplicationController
  before_filter :authenticate_user!, :parameters

  def index
    @title = t 'view.dashboard.index_title'
    @date = DateRange.new(params[:date_range])
    @dead_people = Fee.where('expiration_date BETWEEN ? AND ?', Date.today.at_beginning_of_month, Date.today-1)
    @close_to_death = Fee.where('expiration_date BETWEEN ? AND ?', @date.start, @date.end)
    
    respond_to do |format|
      format.html # index.html.erb
    end 
  end

  private

  def parameters
    params.permit!
  end
end
