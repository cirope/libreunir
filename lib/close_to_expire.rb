class CloseToExpire
  include Summary

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def headers
    [   
      Zone.model_name.human(count: 0), 
      I18n.t("view.loans.close_to_expire"),
      Loan.model_name.human(count: 0)
    ] 
  end

  def rows
    rows = []

    filters.each do |filter|
      row = {}
      loans_filtered = loans.find_by_filter(filter)

      row[:filter] = filter
      row[:value]  = value(loans_filtered)
      row[:amount] = loans_filtered.count

      rows << row
    end

    rows.sort_by { |row| row[:value] }.reverse!.first(Summary::LIMIT)
  end

  def action
    :close_to_expire
  end

  def formatter
    :none
  end

  private

  def loans
    @current_user.loans.close_to_expire
  end

  def value(loans)
    loans.where('progress > 80').count
  end 
end
