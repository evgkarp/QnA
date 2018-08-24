shared_examples_for 'Omniauth callback' do
  let(:user) { create(:user) }
  let(:provider_object) { provider_name }

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    request.env["omniauth.auth"] = mock_auth_hash(provider_object)
  end

  context 'when user is not exist' do
    before do
      get provider_object
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
      auth = mock_auth_hash(provider_object)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      get provider_object
    end

    it 'redirects to root_path' do
      expect(response).to redirect_to(root_path)
    end

    it 'doesnt create user' do
      expect(controller.current_user).to eq user
    end
  end
end
