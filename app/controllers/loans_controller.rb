class LoansController < ApplicationController
  before_action :authenticate_user!

  layout ->(c) { c.request.xhr? ? false : 'application' }

  def show
    @loan = current_user.loans.find(params[:id])
  end


  def expired
    @title = t 'view.loans.expired_title'
    @loans = get_scope.expired.order('delayed_at DESC')

    respond_to do |format|
      format.html # expired.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = get_scope.not_expired.with_expiration.reverse_order

    respond_to do |format|
      format.html # close_to_expired.html.erb
      format.js { render 'index' }
    end
  end

  private

  def get_scope
    current_user.loans.page(params[:page])
  end
end
