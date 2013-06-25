class LoansController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_resource :tag, except: :show, shallow: true
  load_resource :zone, except: :show, shallow: true

  load_and_authorize_resource through: :current_user

  before_action :set_filter, except: :show

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
  end

  def expired
    @title = t 'view.loans.expired_title'
    @loans = @loans.expired

    load_resource_loans

    @loans = @loans.sorted_by_total_debt.page(params[:page]).uniq

    respond_to do |format|
      format.html # expired.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    @loans = @loans.policy

    load_resource_loans

    @loans = @loans.sorted_by_progress.page(params[:page]).uniq

    respond_to do |format|
      format.html # close_to_expired.html.erb
      format.js { render 'index' }
    end
  end

  private
  
  def set_filter
    @filter = @tag || @zone
  end

  def load_resource_loans 
    load_resource_zones
    filter_loans
  end

  def load_resource_zones
    @zones = Zone.find_by_loans(@loans)
  end

  def filter_loans
    @loans = @filter.loans.find_by_loans(@loans) if @filter
  end
end
