class DashboardController < ApplicationController
  before_action :authenticate_user!, :set_filter, :set_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def index
    @title = t 'view.dashboard.index_title'
    @filtrable = true
  end

  def profile
    @title = t 'view.dashboard.profile_title'

    @client = Client.where(product_id: params[:product_id]).first
  end
end
