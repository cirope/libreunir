class SchedulesController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :loan, shallow: true

  before_action :set_schedulable

  load_and_authorize_resource through: :schedulable, shallow: true

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'application' }
  
  # GET /schedules
  def index
    @title = t('view.schedules.index_title')
    @schedules = @schedules.page(params[:page])
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

    if @schedule.save
      flash[:notice] = t('view.schedules.correctly_created')
    end
    respond_with @schedule
  end

  # PATCH /schedules/1
  def update
    @title = t('view.schedules.edit_title')

    if @schedule.update(params[:schedule])
      flash[:notice] = t('view.schedules.correctly_updated')
    end
    respond_with @schedule
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # PATCH /schedules/1/toggle_done
  def toggle_done
    @schedule.toggle_done
    @schedule.save!

    respond_with @schedule
  end

  private

  def schedule_params
    params.require(:schedule).permit(:description, :scheduled_at, :lock_version)
  end

  def set_schedulable
    @schedulable = @loan
  end
end
