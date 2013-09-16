class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_rules(user) : default_rules
  end

  def user_rules(user)
    user.roles.each do |role|
      send("#{role}_rules", user) if respond_to?("#{role}_rules")
    end

    default_rules(user)
  end

  def admin_rules(user)
    can :manage, :all
  end

  def manager_rules(user)
    advisor_rules(user)
  end

  def collector_rules(user)
    can [:close_to_cancel, :capital, :prevision], Loan
  end

  def advisor_rules(user)
    can [:expired, :close_to_expire, :not_renewed], Loan
  end

  def default_rules(user)
    can :switch, User # WARNING
    can :edit_profile, User
    can :update_profile, User
    can :read, Loan
    can :manage, Schedule, { user_id: user.id }
    can :read, Client
    can [:read, :create], Note
    can [:read, :create, :update, :destroy], Tag
    can :read, Zone
  end
end
