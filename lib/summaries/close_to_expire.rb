class Summaries::CloseToExpire
  include Summaries::Summary

  attr_reader :current_user, :filter

  def initialize(current_user, filter = nil)
    @filter       = filter
    @current_user = current_user
  end

  def action
    :close_to_expire
  end

  def formatter
    :none
  end

  private

  def sorted(loans)
    loans.sorted_by_progress
  end

  def loans
    @current_user.loans.policy
  end

  def value(loans)
    loans.where('progress > 80').count
  end 
end
