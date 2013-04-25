class DashboardController < ApplicationController
  before_action :authenticate_user!

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def index
    @title = t 'view.dashboard.index_title'
  end
end
