module Users::Roles
  extend ActiveSupport::Concern
  
  included do
    include RoleModel

    roles :admin, :manager, :advisor, :collector

    after_initialize :set_default_role
  end
  
  def set_default_role
    self.role ||= :advisor
  end

  def role
    self.roles.first.try(:to_sym)
  end
  
  def role=(role)
    self.roles = [role]
  end
end
