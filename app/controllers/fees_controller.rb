class FeesController < ApplicationController
  before_action :authenticate_user!, :set_filter, :set_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def show
    @fee = Fee.find(params[:id])
  end


  def expired
    @title = t 'view.fees.expired_title'
    @fees = get_expired

    render 'index'
  end

  def close_to_expire
    @title = t 'view.fees.close_to_expire_title'
    @fees = get_close_to_expire

    render 'index'
  end

  private

  def get_scope
    @user.fees.page(params[:page])
  end

  def get_expired
    get_scope.without_payment_day.expire_before(@filter.start).filtered_list(params[:q])
  end

  def get_close_to_expire
    get_scope.without_payment_day.expire_after(@filter.start).filtered_list(params[:q])
  end
end
