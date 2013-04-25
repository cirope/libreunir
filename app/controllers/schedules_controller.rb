class SchedulesController < ApplicationController
  before_action :authenticate_user!

  check_authorization
  load_and_authorize_resource :loan, shallow: true
  load_and_authorize_resource through: :loan, shallow: true

  before_action :set_schedulable

  layout ->(c) { c.request.xhr? ? false : 'application' }
  
  # GET /schedules
  # GET /schedules.json
  def index
    @title = t('view.schedules.index_title')
    @schedules = @schedules.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.json
  def show
    @title = t('view.schedules.show_title')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.json
  def new
    @title = t('view.schedules.new_title')

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @schedule }
      format.js
    end
  end

  # GET /schedules/1/edit
  def edit
    @title = t('view.schedules.edit_title')
  end

  # POST /schedules
  # POST /schedules.json
  def create
    @title = t('view.schedules.new_title')

    respond_to do |format|
      if @schedule.save
        format.html { redirect_to @schedule, notice: t('view.schedules.correctly_created') }
        format.json { render json: @schedule, status: :created, location: @schedule }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.json
  def update
    @title = t('view.schedules.edit_title')

    respond_to do |format|
      if @schedule.update(params[:schedule])
        format.html { redirect_to @schedule, notice: t('view.schedules.correctly_updated') }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.json
  def destroy
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to schedules_url }
      format.json { head :ok }
    end
  end

  private

  def schedule_params
    params.require(:schedule).permit(:description, :schedule_at, :lock_version)
  end

  def set_schedulable
    @schedulable = @loan
  end
end
