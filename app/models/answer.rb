class Answer < ApplicationRecord
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true, length: { minimum: 10 }

  scope :ordered_by_best, -> { order(best_answer: :desc) }

  after_commit :new_answer_notification, on: :create

  def set_best
    transaction do
      question.answers.update_all(best_answer: false)
      update!(best_answer: true)
    end
  end

  protected

  def new_answer_notification
    NewAnswerJob.perform_later(self)
  end
end
