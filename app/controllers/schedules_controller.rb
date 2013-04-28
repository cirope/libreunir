class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_filter_date, only: :index

  check_authorization
  load_and_authorize_resource :loan, shallow: true

  before_action :set_schedulable

  load_and_authorize_resource through: :schedulable, shallow: true

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'application' }
  
  # GET /schedules
  def index
    @title = t('view.schedules.index_title')
    @schedules = @schedules.upcoming_or_undone
    @filter_schedules = @schedules.upcoming_or_undone.for_date(@date).sorted

    respond_with @schedules
  end

  # GET /schedules/1
  def show
    @title = t('view.schedules.show_title')
    respond_with @schedule
  end

  # GET /schedules/new
  def new
    @title = t('view.schedules.new_title')
    respond_with @schedule
  end

  # GET /schedules/1/edit
  def edit
    @title = t('view.schedules.edit_title')
  end

  # POST /schedules
  def create
    @title = t('view.schedules.new_title')

    respond_to do |format|
      if @schedule.save && @schedulable.nil?
        format.js { redirect_to schedules_url, notice: t('view.schedules.correctly_created'), format: :js }
      else
        format.js
      end
    end
  end

  # PATCH /schedules/1
  def update
    @title = t('view.schedules.edit_title')

    respond_to do |format|
      if @schedule.update(params[:schedule])
        format.js { redirect_to schedules_url, notice: t('view.schedules.correctly_updated'), format: :js }
      else
        format.js
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # PATCH /schedules/1/toggle_done
  def toggle_done
    @schedule.toggle_done

    respond_with @schedule
  end

  private

  def schedule_params
    params.require(:schedule).permit(:description, :scheduled_at, :lock_version)
  end

  def set_schedulable
    @schedulable = @loan
  end

  def set_filter_date
    @date = Timeliness.parse(params[:date], zone: :local) || Time.now
  end
end
