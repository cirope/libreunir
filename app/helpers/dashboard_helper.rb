module DashboardHelper
  def date_payments(payment)
    if payment.paid_at
      'muted'
    elsif payment.expired?
      'error'
    else
      'success'
    end
  end

  def expired_payments_path_with_params
    expired_payments_path(users_id: @filter.user_id)
  end

  def close_to_expire_payments_path_with_params
    close_to_expire_payments_path(user_id: @filter.user_id)
  end
end
