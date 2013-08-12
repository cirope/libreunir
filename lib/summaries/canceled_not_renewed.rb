class Summaries::CanceledNotRenewed
  include Summaries::Summary

  attr_reader :current_user, :filter, :query

  def initialize(current_user, filter = nil, query = nil)
    @filter       = filter
    @query        = query
    @current_user = current_user
  end

  def action
    :canceled_not_renewed
  end

  def formatter
    :none
  end

  private

  def sorted(loans)
    loans.sorted_by_canceled_at
  end

  def loans
    @current_user.loans.canceled
  end

  def value(loans)
    loans.canceled.count
  end 
end
