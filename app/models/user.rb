class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: %i[vkontakte github]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = set_email(auth)
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation_notification!
      user.save!
      user.create_authorization(auth)
    end
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def add_subscription(question)
    subscriptions.create!(question: question)
  end

  def subscribed?(question)
    subscriptions.exists?(question: question)
  end

  protected

  def self.set_email(auth)
    if auth.info[:email].blank?
      "#{auth.provider + auth.uid.to_s}@temporary.com"
    else
      auth.info[:email]
    end
  end
end
