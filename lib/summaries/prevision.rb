class Summaries::Prevision
  include Summaries::Summary

  attr_reader :current_user, :filter, :query

  def initialize(current_user, filter = nil, query = nil)
    @filter       = filter
    @query        = query
    @current_user = current_user
  end

  def action
    :prevision
  end

  def value_formatted(value)
    number_to_currency value
  end

  private
    def sorted(loans)
      loans.sorted_by_total_debt
    end

    def loans
      @current_user.loans.prevision
    end

    def value(loans)
      loans.sum('total_debt')
    end 
end
