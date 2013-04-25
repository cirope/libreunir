class SchedulesController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :loan, shallow: true
  load_and_authorize_resource through: :loan, shallow: true

  before_action :set_schedulable

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'application' }
  
  # GET /schedules
  # GET /schedules.json
  def index
    @title = t('view.schedules.index_title')
    @schedules = @schedules.page(params[:page])
    respond_with @schedules
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @title = t('view.schedules.show_title')
    respond_with @schedule
  end

  # GET /schedules/new
  # GET /schedules/new.json
  def new
    @title = t('view.schedules.new_title')
    respond_with @schedule
  end

  # GET /schedules/1/edit
  def edit
    @title = t('view.schedules.edit_title')
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @title = t('view.schedules.new_title')

    if @schedule.save
      flash[:notice] = t('view.schedules.correctly_created')
    end
    respond_with @schedule
  end

  # PUT /schedules/1
  # PUT /schedules/1.json
  def update
    @title = t('view.schedules.edit_title')

    if @schedule.update(params[:schedule])
      flash[:notice] = t('view.schedules.correctly_updated')
    end
    respond_with @schedule
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy
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
