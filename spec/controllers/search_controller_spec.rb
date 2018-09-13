require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'renders result template' do
      get :search
      expect(response).to render_template :search
    end

    %w(Everywhere Question Answer Comment User).each do |category|
      it "search with params: #{category}" do
        expect(Search).to receive(:search).with('something', category)
        get :search, params: { query: 'something', category: category }
      end
    end
  end
end
