class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments

  validates :title, :body, presence: true, length: { minimum: 10 }
end
