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

  def regular_rules(user)
    can :edit_profile, User
    can :update_profile, User
  end

  def default_rules(user)
    can [:read, :expired, :close_to_expire], Loan
    can :manage, Schedule, { user_id: user.id }
    can :read, Client
    can [:read, :create], Note
    can [:read, :create, :update, :destroy], Tag
    can :read, Zone
  end
end
