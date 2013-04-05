class DashboardController < ApplicationController
  before_filter :authenticate_user!, :parameters, :set_dates, :set_current_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def index
    @title = t 'view.dashboard.index_title'
    @filtrable = true

    @expired = get_scope.where('fees.expiration_date BETWEEN ? AND ? AND fees.payment_date IS NULL AND fees.expiration_date < ?',
                 @date.start, @date.end, Date.today).last(30)
    @close_to_expire = get_scope.where('fees.expiration_date BETWEEN ? AND ? AND fees.payment_date IS NULL',
                         @date.start, @date.end).last(30)
    @close_to_expire = @close_to_expire-@expired if @close_to_expire && @expired
  end

  def expired
    @title = t 'view.dashboard.expired_title'
    @printable = true
    @filtrable = true
    @printing = params[:print]

    @fees = get_scope.where('fees.expiration_date BETWEEN ? AND ? AND fees.payment_date IS NULL AND fees.expiration_date < ?',
      @date.start, @date.end, Date.today).filtered_list(params[:q])

    @fees = @printing.present? ? @fees : @fees.page(params[:page])
    render 'dashboard/debts'
  end

  def expiring_info
    @fee = Fee.find(params[:id])
  end

  def close_to_expire
    @title = t 'view.dashboard.close_to_expire_title'
    @printable = true
    @filtrable = true
    @printing = params[:print]

    @fees = get_scope.where('fees.expiration_date BETWEEN ? AND ?',
      @date.start, @date.end).filtered_list(params[:q])

    @fees = @printing.present? ? @fees : @fees.page(params[:page])
    render 'dashboard/debts'
  end

  def profile
    @title = t 'view.dashboard.profile_title'

    @client = Client.where('product_id = ?', params[:product_id]).first
  end

  private

  def parameters
    params.permit!
  end

  def set_dates
    @date = DateRange.new(params[:date_range])
  end

  # TODO: Refactor this
  def set_current_user
    if params[:users] && !params[:users][:user_id].blank?
      @user = User.find(params[:users][:user_id])
    else
      @user = current_user
    end
  end

  # TODO: Refactor this
  def get_scope
    if (params[:users] && params[:users][:user_id]) || current_user.admin?
      Fee.all
    else
      @user.fees
    end
  end
end
