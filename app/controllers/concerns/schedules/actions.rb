module Schedules::Actions
  extend ActiveSupport::Concern

  # GET /schadules/calendar
  def calendar
  end 

  # PUT /schedules/mark_as_done
  def mark_as_done
    mark_as { |schedule| schedule.mark_as_done }
  end

  # PUT /schedules/mark_as_pending
  def mark_as_pending
    mark_as { |schedule| schedule.mark_as_pending }
  end

  # PUT /schedules/move
  def move
    if @schedules.present? && @date
      @schedules.each do |schedule|
        schedule.update_attribute(:scheduled_at, schedule.scheduled_at.change(
          year: @date.year, month: @date.month, day: @date.day)
        )
      end
      redirect_to :back
    else
      head :ok
    end
  end

  # GET /schedules/pending
  def pending
    @schedules = @schedules.pending.sorted.group_by { |s| s.scheduled_at.to_date }

    render layout: 'application'
  end

  private
  
  def mark_as(&block)
    if @schedules.present?
      @schedules.each(&block)

      respond_to do |format|
        format.js { render 'toggle_done' }
      end
    else
      head :ok 
    end
  end
end
