class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters

  protect_from_forgery

  helper_method :today_schedules_count, :pending_schedules_past_count,
    :pending_schedules_future_count

  before_action :clear_referer
  after_action -> { expires_now if user_signed_in? }

  def user_for_paper_trail
    current_user.try(:id)
  end

  rescue_from Exception do |exception|
    begin
      case exception
        when ActionController::RedirectBackError then redirect_to root_url
      end
    rescue => ex
      log_exception(ex)
    end
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def today_schedules_count
    @_today_schedules_count ||= current_user.schedules.for_date_of_day(Date.today).count
  end

  def pending_schedules_past_count
    @pending_past_count ||= current_user.schedules.past.count
  end

  def pending_schedules_future_count
    @pending_future_count ||= current_user.schedules.future.count
  end

  def log_exception(exception)
    logger.error(([exception, ''] + exception.backtrace).join("\n"))
  end

  def clear_referer
    session.delete(:referer) if controller_name != 'schedules'
  end
end
