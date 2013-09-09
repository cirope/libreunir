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

  def zones
    @current_user.branches_zones.filter_by_loans(loans)
  end 

  def tags
    @current_user.branches_tags.filter_by_loans(loans)
  end

  private
    def sorted(loans)
      loans.sorted_by_progress
    end

    def loans
      @current_user.branches_loans.close_to_cancel
    end

    def value(loans)
      loans.where('progress >= 75').count
    end
end
