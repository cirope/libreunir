module Application::Tenancy
  extend ActiveSupport::Concern

  def current_ability
    @_current_ability ||= Ability.new(selected_user)
  end

  private
    def selected_user
      @_selected_user ||= (current_tenant || current_user)
    end

    def current_tenant
      @_current_tenant ||= User.find_by(id: session[:tenant_id]) if session[:tenant_id]
    end
end
