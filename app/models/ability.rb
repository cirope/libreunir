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
    can :read, User
    can :read, Loan
    can :manage, Schedule, { user_id: user.id }
  end
end
