class LoansController < ApplicationController
  before_action :authenticate_user!, :set_filter, :set_user

  layout ->(c) { c.request.xhr? ? false : 'application' }

  def show
    @loan = @user.loans.find(params[:id])
  end


  def expired
    @title = t 'view.loans.expired_title'
    @loans = get_scope.expired.expire_before(@filter.start)

    render 'index'
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = get_scope.not_expired.expire_on_or_after(@filter.start)

    render 'index'
  end

  private

  def get_scope
    @user.loans.page(params[:page])
  end
end
