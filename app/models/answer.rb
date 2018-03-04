class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  scope :ordered_by_best, -> { order(best_answer: :desc) }

  def set_best
    transaction do
      question.answers.update_all(best_answer: false)
      update!(best_answer: true)
    end
  end
end
