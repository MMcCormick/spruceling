class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      cannot :read, Order
      can :read, Order, :user_id => user.id
      can :manage, Box, :user_id => user.id
      can :manage, Item, :user_id => user.id
    end
  end
end