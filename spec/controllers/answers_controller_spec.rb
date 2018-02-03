require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:invalid_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

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

      it 'saves the new answer in the database with valid user' do
        expect { create_answer }.to change(user.answers, :count).by(1)
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
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { answer }
    let!(:second_answer) { create(:answer, question: question, user: invalid_user) }

    context 'valid user' do
      it 'deletes answer' do
        expect {
          delete :destroy, params: { id: answer, user: user }
          }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: answer, question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'invalid user' do
      it 'can not delete answer' do
        expect {
          delete :destroy, params: { id: second_answer, question_id: question }
          }.to_not change(Answer, :count)
      end

      it 'redirects to question show view' do
        delete :destroy, params: { id: second_answer, question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
  end
end
