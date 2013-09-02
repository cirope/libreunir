class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters
  include Application::Tenancy

  protect_from_forgery

  helper_method :selected_user, :current_tenant
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
    reset_session
    new_user_session_path
  end

  def today_schedules_count
    @_today_schedules_count ||= selected_user.schedules.for_date_of_day(Date.today).count
  end
  helper_method :today_schedules_count

  def pending_schedules_past_count
    @pending_past_count ||= selected_user.schedules.past.count
  end
  helper_method :pending_schedules_past_count

  def pending_schedules_future_count
    @pending_future_count ||= selected_user.schedules.future.count
  end
  helper_method :pending_schedules_future_count

  def log_exception(exception)
    logger.error(([exception, ''] + exception.backtrace).join("\n"))
  end

  def clear_referer
    session.delete(:referer) if controller_name != 'schedules'
  end
end
