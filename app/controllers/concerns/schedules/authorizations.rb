module Schedules::Authorizations
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :load_date, only: [:index, :move]
    before_action :load_today, only: [:new, :calendar]

    check_authorization
    load_resource :loan, shallow: true

    before_action :set_schedulable
    before_action :load_referer, only: [:index]

    load_and_authorize_resource through: [:schedulable, :selected_user]

    before_action :set_current_tenant, only: [:create, :update]
    before_action :load_schedules, only: [:mark_as_done, :mark_as_pending, :move]
  end

  private

  def schedule_params
    params.require(:schedule).permit(:description, :scheduled_at, :remind_me, :lock_version)
  end

  def set_schedulable
    @schedulable = @loan
  end

  def load_referer
    session[:referer] = request.referer if session[:referer].blank? && @loan
  end

  def load_date
    if params[:date].present?
      @date = Timeliness.parse(params[:date], zone: :local)
    else
      redirect_to schedules_url(Date.today)
    end
  end

  def load_today
    @date = Timeliness.parse(params[:date], zone: :local) || Time.zone.now
  end

  def load_schedules
    if params[:schedule_ids].present?
      @schedules = @schedules.where(id: params[:schedule_ids]) 
    else
      @schedules = []
    end
  end

  def set_current_tenant
    @schedule.tenant = current_user if current_tenant
  end
end
