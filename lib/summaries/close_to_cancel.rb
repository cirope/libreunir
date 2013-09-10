class Summaries::CloseToCancel
  include Summaries::Summary

  attr_reader :current_user, :filter, :query

  def initialize(current_user, filter = nil, query = nil)
    @filter       = filter
    @query        = query
    @current_user = current_user
  end

  def action
    :close_to_cancel
  end

  def value_formatted(value)
    value
  end

  private
    def sorted(loans)
      loans.sorted_by_progress
    end

    def loans
      @current_user.loans.close_to_cancel
    end

    def value(loans)
      loans.count
    end
end
