class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, length: { minimum: 10 }
  validates_associated :question
end
