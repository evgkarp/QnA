class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  def set_only_one_best_answer
    best_answers = self.class.where(best_answer: true)
    best_answers&.each do |answer|
      if answer != self
        answer.best_answer = false
        answer.save
      end
    end
  end
end
