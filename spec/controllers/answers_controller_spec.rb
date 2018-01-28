require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
    sign_in_user

      subject(:create_answer) do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
      end

      it 'saves the new answer in the database' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        create_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
    sign_in_user

      subject(:create_invalid_answer) do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
      end

      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        create_invalid_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
