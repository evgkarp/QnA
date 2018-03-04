require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:invalid_user) { create(:user) }
  let(:second_question) { create(:question, user: invalid_user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested guestion to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      subject(:create_question) do
        post :create, params: { question: attributes_for(:question) }
      end

      it 'redirects to show view' do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'saves the new question in the database with valid user' do
        expect { create_question }.to change(user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      subject(:create_invalid_question) do
        post :create, params: { question: attributes_for(:invalid_question) }
      end

      it 'does not save the question' do
        expect { create_invalid_question }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }
    before { second_question }

    context 'valid user' do
      it 'deletes question' do
        expect {
          delete :destroy, params: { id: question, format: :js }
          }.to change(Question, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'invalid user' do
      it 'can not delete question' do
        expect { delete :destroy, params: {
          id: second_question, format: :js
          } }.to_not change(Question, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: second_question, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    before { question }
    subject(:update_question) do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }
      end

    it 'assigns the question' do
      update_question
      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      patch :update, params: {
        id: question, question: { title: 'my new title', body: 'my new body' }, format: :js
      }
      question.reload
      expect(question.title).to eq 'my new title'
      expect(question.body).to eq 'my new body'
    end

    it 'render update template' do
      update_question
      expect(response).to render_template :update
    end
  end
end
