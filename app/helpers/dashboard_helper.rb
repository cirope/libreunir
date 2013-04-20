module DashboardHelper
  def date_fees(fee)
    if fee.payment_date
      'muted'
    elsif fee.expired?
      'error'
    else
      'success'
    end
  end

  def expired_fees_path_with_params
    expired_fees_path(users_id: @filter.user_id)
  end

  def close_to_expire_fees_path_with_params
    close_to_expire_fees_path(user_id: @filter.user_id)
  end
end
