class Summaries::NotRenewed
  include Summaries::Summary

  attr_reader :current_user, :filter, :query

  def initialize(current_user, filter = nil, query = nil)
    @filter       = filter
    @query        = query
    @current_user = current_user
  end

  def action
    :not_renewed
  end

  def value_formatted(value)
    number_to_percentage value, precision: 0
  end

  private

  def sorted(loans)
    loans.sorted_by_canceled_at
  end

  def loans
    @current_user.loans.canceled
  end

  def value(loans)
    ((loans.count * 100) / @current_user.loans.canceled.count).to_f rescue 0
  end 
end
