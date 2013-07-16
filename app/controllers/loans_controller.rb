class LoansController < ApplicationController
  before_action :authenticate_user!
  before_action :load_tag, except: :show

  load_resource :zone, except: :show, shallow: true

  before_action :set_filter, :load_resources, except: :show

  load_and_authorize_resource through: :current_user, only: :show

  layout ->(c) { c.request.xhr? ? false : 'columns' }

  def show
    @total_debt = current_user.loans.sum('total_debt')
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
      format.html # close_to_expired.html.erb
      format.js { render 'index' }
    end
  end

  private
  
  def load_resources
    summary = "Summaries::#{action_name.camelize}".constantize.new(current_user, @filter)

    @loans = summary.loans_filtered.page(params[:page]).uniq
    @zones = summary.zones
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
