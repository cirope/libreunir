class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :load_summaries

  def index
    @title = t 'view.dashboard.index_title'
  end

  private

  def load_summaries
    @summaries = Summaries::Summary.classes.map { |klass| klass.new(current_user) }
  end
end
