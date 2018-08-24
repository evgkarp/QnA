require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe '#vkontakte' do
    let(:provider_name) { :vkontakte }

    it_behaves_like 'Omniauth callback'
  end

  describe '#github' do
    let(:provider_name) { :github }

    it_behaves_like 'Omniauth callback'
  end
end
