class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true, length: { minimum: 10 }

  def answers_ordered_by_best
    answers.order(best_answer: :desc)
  end
end
