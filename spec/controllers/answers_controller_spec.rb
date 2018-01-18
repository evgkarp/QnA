require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    before { get :new, params: { id: answer, question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:create_answer) { post :create, params: {
      answer: attributes_for(:answer), question_id: question } }

    let(:create_invalid_answer) { post :create, params: {
      answer: attributes_for(:invalid_answer), question_id: question } }

    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        create_answer
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        create_invalid_answer
        expect(response).to render_template :new
      end
    end
  end
end
