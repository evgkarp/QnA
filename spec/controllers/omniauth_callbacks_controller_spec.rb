require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe '#vkontakte' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
    end

    context 'when user is not exist' do
      before do
        get :vkontakte
      end

      let(:new_user) { User.find_for_oauth(request.env['omniauth.auth']) }

      it 'redirects to edit_email_path' do
        expect(response).to redirect_to(edit_email_path(new_user))
      end

      it 'creates new user' do
        expect(new_user).to_not eq nil
      end
    end

    context 'when user already exist' do
      before do
        auth = mock_auth_hash(:vkontakte)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :vkontakte
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end

  describe '#github' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:github)
    end

    context 'when user is not exist' do
      before do
        get :github
      end

      let(:new_user) { User.find_for_oauth(request.env['omniauth.auth']) }

      it 'redirects to edit_email_path' do
        expect(response).to redirect_to(edit_email_path(new_user))
      end

      it 'creates new user' do
        expect(new_user).to_not eq nil
      end
    end

    context 'when user already exist' do
      before do
        auth = mock_auth_hash(:github)
        create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
        get :github
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to(root_path)
      end

      it 'doesnt create user' do
        expect(controller.current_user).to eq user
      end
    end
  end
end
