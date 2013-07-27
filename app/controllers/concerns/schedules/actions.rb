module Schedules::Actions
  extend ActiveSupport::Concern

  # GET /schadules/calendar
  def calendar
  end 

  # PUT /schedules/done
  def done
    if params[:schedule_ids].present?
      @schedules = current_user.schedules.where(id: params[:schedule_ids])
      @schedules.each { |schedule| schedule.mark_as_done }

      respond_to do |format|
        format.js { render 'toggle_done' }
      end
    else
      head :ok 
    end
  end

  # PUT /schedules/pending
  def pending
    if params[:schedule_ids].present?
      @schedules = current_user.schedules.where(id: params[:schedule_ids])
      @schedules.each { |schedule| schedule.mark_as_pending }

      respond_to do |format|
        format.js { render 'toggle_done' }
      end
    else
      head :ok 
    end
  end

  # PUT /schedules/move
  def move
    if params[:schedule_ids].present? && @date
      @schedules = current_user.schedules.where(id: params[:schedule_ids])

      @schedules.each do |schedule|
        schedule.update_attribute(:scheduled_at, schedule.scheduled_at.change(
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

  # GET /schedules/search
  def search
    @schedules = @schedules.for_date_of_day(@date).sorted
  end
end
