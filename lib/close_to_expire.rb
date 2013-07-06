class CloseToExpire
  include Summary

  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
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
