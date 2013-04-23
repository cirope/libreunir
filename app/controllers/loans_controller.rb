class LoansController < ApplicationController
  before_action :authenticate_user!, :set_filter, :set_user

  layout ->(controller) { controller.request.xhr? ? false : 'application' }

  def show
    @loan = @user.loans.find(params[:id])
  end


  def expired
    @title = t 'view.loans.expired_title'
    @loans = get_expired

    render 'index'
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = get_close_to_expire

    render 'index'
  end

  private

  def get_scope
    @user.loans.page(params[:page])
  end

  def get_expired
    get_scope.pending.expire_before(@filter.start)
  end

  def get_close_to_expire
    get_scope.pending.expire_after(@filter.start)
  end
end
