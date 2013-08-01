class SchedulesController < ApplicationController
  include Schedules::Authorizations 
  include Schedules::Actions

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

    if @schedule.save && @schedulable.nil?
      respond_to do |format|
        format.js {
          redirect_to schedules_url(date: @schedule.scheduled_at.to_date), format: :js
        }
      end
    end
  end

  # PATCH /schedules/1
  def update
    @title = t('view.schedules.edit_title')

    if @schedule.update(schedule_params)
      respond_to do |format|
        format.js { 
          redirect_to schedules_url(date: @schedule.scheduled_at.to_date), format: :js
        }
      end
    end
  rescue ActiveRecord::StaleObjectError
    redirect_to edit_schedule_url(@schedule), alert: t('view.schedules.stale_object_error')
  end

  # DELETE /schedules/1
  def destroy
    @schedule.destroy
  end
end
