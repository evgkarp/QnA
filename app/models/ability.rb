class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :destroy, Attachment, user_id: user.id
    can :make_best, Answer, question: { user_id: user.id }
    can [:vote_for, :vote_against], [Question, Answer] do |resource|
      !user.author_of?(resource) && !resource.has_vote?(user)
    end
    can :reset_vote, [Question, Answer] do |resource|
      resource.votes.where(user: user).where(votable: resource) && !user.author_of?(resource)
    end
  end
end
