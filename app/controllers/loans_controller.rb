class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :load_tag, except: :show

  load_resource :zone, except: :show, shallow: true
  before_action :set_filter, :set_print, :load_resources, except: :show

  load_and_authorize_resource through: :current_scope, only: :show

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
    @total_debt = current_scope.loans.sum('total_debt')
  end

  def expired
    @title = t 'view.loans.expired_title'
    respond_to_format
  end

  def close_to_expire
    @title = t 'view.loans.close_to_expire_title'
    respond_to_format
  end

  def close_to_cancel
    @title = t 'view.loans.close_to_cancel_title'
    respond_to_format
  end

  def not_renewed
    @title = t 'view.loans.not_renewed_title'
    respond_to_format
  end

  def capital
    @title = t 'view.loans.capital_title'
    respond_to_format
  end

  def prevision
    @title = t 'view.loans.prevision_title'
    respond_to_format
  end

  private
    def load_resources
      @searchable = true
      @summary = "Summaries::#{action_name.camelize}"
        .constantize.new(current_scope, @filter, params[:q])

      @loans = @print ?
        @summary.loans_sorted.uniq :
        @summary.loans_sorted.page(params[:page]).uniq
    end

    def set_filter
      @filter = @tag || @zone
    end

    def set_print
      @print = true if params[:print] == 'true'
    end

    def load_tag
      @tag = Tag.find(params[:tag_id]) if params[:tag_id].present?
    rescue
      redirect_to tag_id: nil
    end

    def respond_to_format
      respond_to do |format|
        format.html
        format.js { render @print ? 'print' : 'index' }
      end
    end
end
