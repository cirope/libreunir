module Users::Roles
  extend ActiveSupport::Concern

  included do
    include RoleModel

    roles :admin, :advisor, :manager, :collector

    after_initialize :set_default_role
  end

  module ClassMethods
    def filtered_role(role)
      role.present? ? where(roles_mask: mask_for(role)) : all
    end
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
