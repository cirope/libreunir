class DashboardController < ApplicationController
  before_filter :authenticate_user!, :set_dates, :set_current_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def index
    @title = t 'view.dashboard.index_title'
    @filtrable = true

    @expired = get_expired.last(30)
    @close_to_expire = get_close_to_expire.last(30)

    @close_to_expire = @close_to_expire - @expired if @close_to_expire && @expired
  end

  def expired
    @title = t 'view.dashboard.expired_title'
    @fees = get_expired

    default_render_expirations
  end

  def close_to_expire
    @title = t 'view.dashboard.close_to_expire_title'
    @fees = get_close_to_expire

    default_render_expirations
  end

  def expiring_info
    @fee = Fee.find(params[:id])
  end

  def profile
    @title = t 'view.dashboard.profile_title'

    @client = Client.where(product_params).first
  end

  private

  def product_params
    params.permit(:product_id)
  end

  def daterange_params
    params.permit(:date_range).permit(
      :start, :end
    )
  end

  def users_params
    params.require(:users).permit(
      :id
    )
  end

  def set_dates
    @date = DateRange.new(daterange_params)
  end

  def set_current_user
    if params[:users] && params[:users][:id].present?
      @user = User.where(users_params).first
    else
      @user = current_user
    end
  end

  def get_scope
    if @user != current_user
      @user.fees
    else
      Fee.all
    end
  end

  def get_expired
    get_scope.where(daterange_params).without_payment_day.expired_before(Date.today).
      filtered_list(params[:q])
  end

  def get_close_to_expire
    get_scope.where(daterange_params).without_payment_day.
      will_expire_after(Date.today).expired_before(Date.today.at_end_of_month).filtered_list(params[:q])
  end

  def default_render_expirations
    @printable = true
    @filtrable = true
    @printing = params[:print]

    @fees = @printing.present? ? @fees : @fees.page(params[:page])
    render 'dashboard/debts'
  end
end
