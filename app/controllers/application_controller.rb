class ApplicationController < ActionController::Base
  include Application::CancanStrongParameters

  protect_from_forgery

  helper_method :flash_hash, :pending_schedules_count

  after_action -> { expires_now if user_signed_in? }

  def user_for_paper_trail
    current_user.try(:id)
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    dashboard_url  
  end

  def flash_hash
    request.xhr? ? flash.now : flash
  end

  def pending_schedules_count
    current_user.schedules.pending.count
  end
end
