require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:author) { create(:user) }
  let!(:question) { create(:question, user: author) }

  describe 'POST #create' do
    subject(:create_subscription) { post :create, params: { question_id: question.id, user_id: user.id, format: :js } }
    sign_in_user

    it 'assigns question to @question' do
       create_subscription
       expect(assigns(:subscription).question).to eq question
    end

    it 'saves the new subscription to database' do
      expect{create_subscription}.to change(Subscription, :count).by(1)
    end

    it 'renders create template' do
      create_subscription
      expect(response).to render_template "common/subscribe"
    end
  end

  describe 'DELETE #destroy' do
    before {sign_in(user)}
    let!(:subscription) { create(:subscription, question: question, user: user) }

    it 'deletes subscription' do
      expect { delete :destroy, params: { question_id: question.id, user_id: user.id, id: subscription }, format: :js  }.to change(Subscription, :count).by(-1)
    end

    it 'assigns subscription to @subscription' do
      expect(assigns("subscription")).to eq @subscription
    end

    it 'renders destroy template' do
      delete :destroy, params: { question_id: question.id, user_id: user.id, id: subscription }, format: :js
      expect(response).to render_template "common/subscribe"
    end
  end
end
