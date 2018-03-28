module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_for(user)
    votes.create!(user_id: user.id, point: 1)
  end

  def vote_against(user)
    votes.create!(user_id: user.id, point: -1)
  end

  def rating
    votes.sum(:point)
  end

  def has_vote?(user)
    votes.exists?(user_id: user.id)
  end

  def reset_vote(user)
    votes.where(user: user, votable_id: id).delete_all
  end
end
