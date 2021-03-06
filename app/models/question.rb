class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true, length: { minimum: 10 }

  scope :last_day, -> { where(created_at: 24.hours.ago..Time.zone.now) }

  scope :sorted, -> { order(:created_at) }

  after_commit :subscribe, on: :create

  protected

  def subscribe
    subscriptions.create!(user: user)
  end
end
