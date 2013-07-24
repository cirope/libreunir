class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_date, only: [:index, :search, :new, :move, :calendar]

  check_authorization
  load_resource :loan, shallow: true

  before_action :set_schedulable

  load_and_authorize_resource through: :schedulable, shallow: true 

  respond_to :html, :js

  layout ->(c) { c.request.xhr? ? false : 'columns' }
  
  # GET /schedules
  def index
    @title = t('view.schedules.index_title')
    @days = @schedules.for_date_of_month(@date).uniq
    @schedules = @schedules.for_date_of_day(@date).sorted
  end

  # GET /schedules/1
  def show
    @title = t('view.schedules.show_title')
    @total_debt = current_user.loans.sum('total_debt')
  end

  # GET /schedules/new
  def new
    @title = t('view.schedules.new_title')
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
        format.js { 
          redirect_to schedules_url(date: @schedule.scheduled_at.to_date), format: :js 
        }
      else
        format.js
      end
    end
  end

  # PATCH /schedules/1
  def update
    @title = t('view.schedules.edit_title')

    respond_to do |format|
      if @schedule.update(schedule_params)
        format.js { 
          redirect_to schedules_url(date: @schedule.scheduled_at.to_date), format: :js 
        }
      else
        format.js
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # DELETE /schedules/1
  def destroy
    @schedule.destroy
  end

  # GET /schadules/calendar
  def calendar
  end

  # PUT /schedules/toggle_done
  def toggle_done
    if params[:schedule_ids].present?
      @schedules = Schedule.find(params[:schedule_ids])
      @schedules.each { |schedule| schedule.toggle_done }
    else
      head :ok
    end
  end

  # PUT /schedules/move
  def move
    if params[:schedule_ids].present? && @date 
      @schedules = Schedule.find(params[:schedule_ids])

      @schedules.each do |schedule| 
        schedule.update(scheduled_at: schedule.scheduled_at.change(
          year: @date.year, month: @date.month, day: @date.day)
        )
      end
  
      respond_to do |format|
        format.js { 
          redirect_to schedules_url(date: @date.to_date), format: :js 
        }
      end
    else
      head :ok
    end
  end

  def search
    @schedules = @schedules.for_date_of_day(@date).sorted
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
end
