require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:authorizations) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:invalid_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'author' do
      expect(user).to be_author_of(question)
    end

    it 'not author' do
      expect(invalid_user).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456')}

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'vkontakte', uid: '123456')

        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: user.email })}

      context 'user already exist' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: 'new@user.com' })}

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)

          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create :question, user: user }

  describe '#add_subscription' do
    it 'subscribes the user to the question' do
      other_user.add_subscription(question)
      expect(other_user.subscriptions.first).to eq question.subscriptions.first
    end
  end

  describe '#subscribed?' do
    it 'returns true if the user has subscription for the question' do
      other_user.add_subscription(question)
      expect(other_user.subscribed?(question)).to eq true
    end

    it 'returns false if the user has not subscription for the question' do
      expect(other_user.subscribed?(question)).to eq false
    end
  end
end
