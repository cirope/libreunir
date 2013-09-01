class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters

  protect_from_forgery

  before_action :clear_referer
  after_action -> { expires_now if user_signed_in? }

  def user_for_paper_trail
    current_user.try(:id)
  end

  def current_ability
    @_current_ability ||= Ability.new(selected_user)
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

  def selected_user
    @_selected_user ||= (current_tenant || current_user)
  end
  helper_method :selected_user

  def tenant
    @_tenant ||= User.find_by(id: session[:tenant_id]) if session[:tenant_id]
  end

  def current_tenant
    if tenant
      unless current_user.can_show?(tenant)
        redirect_to root_url, alert: t('errors.access_denied')
      else
        tenant
      end
    end
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
