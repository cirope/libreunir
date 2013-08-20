class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters

  protect_from_forgery

  helper_method :pending_schedules_count

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

  def pending_schedules_count
    current_user.schedules.pending.count
  end

  def log_exception(exception)
    logger.error(([exception, ''] + exception.backtrace).join("\n"))
  end
end
