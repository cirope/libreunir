module Schedules::Authorizations
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :load_date, only: [:index, :new, :move, :calendar, :pending]

    check_authorization
    load_resource :loan, shallow: true

    before_action :set_schedulable

    load_and_authorize_resource through: [:schedulable, :current_user] 

    before_action :load_schedules, only: [:mark_as_done, :mark_as_pending, :move]
  end

  private

  def schedule_params
    params.require(:schedule).permit(:description, :scheduled_at, :remind_me, :lock_version)
  end

  def set_schedulable
    @schedulable = @loan
  end

  def load_date
    @date = Timeliness.parse(params[:date], zone: :local) || Time.zone.now
  end

  def load_schedules
    if params[:schedule_ids].present?
      @schedules = @schedules.where(id: params[:schedule_ids]) 
    else
      @schedules = []
    end
  end
end
