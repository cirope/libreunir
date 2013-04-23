module DashboardHelper
  def expired_loans_path_with_params
    expired_loans_path(users_id: @filter.user_id)
  end

  def close_to_expire_loans_path_with_params
    close_to_expire_loans_path(user_id: @filter.user_id)
  end
end
