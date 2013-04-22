class PaymentsController < ApplicationController
  before_action :authenticate_user!, :set_filter, :set_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def show
    @payment = Payment.find(params[:id])
  end


  def expired
    @title = t 'view.payments.expired_title'
    @payments = get_expired

    render 'index'
  end

  def close_to_expire
    @title = t 'view.payments.close_to_expire_title'
    @payments = get_close_to_expire

    render 'index'
  end

  private

  def get_scope
    @user.payments.page(params[:page])
  end

  def get_expired
    get_scope.pending.expire_before(@filter.start).filtered_list(params[:q])
  end

  def get_close_to_expire
    get_scope.pending.expire_after(@filter.start).filtered_list(params[:q])
  end
end
