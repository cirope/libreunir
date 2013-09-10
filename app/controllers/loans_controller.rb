class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :load_tag, except: :show

  load_resource :zone, except: :show, shallow: true
  before_action :set_filter, :load_resources, except: :show

  load_and_authorize_resource through: :current_scope, only: :show

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
    @total_debt = current_scope.loans.sum('total_debt')
  end

  def expired
    @title = t 'view.loans.expired_title'

    respond_to do |format|
      format.html # expired.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'

    respond_to do |format|
      format.html # close_to_expire.html.erb
      format.js { render 'index' }
    end
  end

  def close_to_cancel
    @title = t 'view.loans.close_to_cancel_title'

    respond_to do |format|
      format.html # close_to_cancel.html.erb
      format.js { render 'index' }
    end
  end

  def not_renewed
    @title = t 'view.loans.not_renewed_title'

    respond_to do |format|
      format.html # not_renewed.html.erb
      format.js { render 'index' }
    end
  end

  def capital
    @title = t 'view.loans.capital_title'

    respond_to do |format|
      format.html # capital.html.erb
      format.js { render 'index' }
    end
  end

  private
    def load_resources
      @searchable = true
      @summary = "Summaries::#{action_name.camelize}".constantize.new(current_scope, @filter, params[:q])

      @loans = @summary.loans_sorted.page(params[:page]).uniq
    end

    def set_filter
      @filter = @tag || @zone
    end

    def load_tag
      @tag = Tag.find(params[:tag_id]) if params[:tag_id].present?
    rescue
      redirect_to tag_id: nil
    end
end
