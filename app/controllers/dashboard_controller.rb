class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :load_summaries

  def index
    @title = t 'view.dashboard.index_title'
  end

  private

  def load_summaries
    klasses = case current_scope
      when Branch
        [Summaries::Capital, Summaries::Prevision, Summaries::CloseToCancel]
      when User
        [Summaries::Expired, Summaries::CloseToExpire, Summaries::NotRenewed]
    end

    @summaries = klasses.map { |klass| klass.new(current_scope) }
  end
end
