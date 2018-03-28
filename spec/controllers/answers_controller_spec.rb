require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:invalid_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:second_question) { create(:question, user: invalid_user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:second_answer) { create(:answer, question: question, user: invalid_user) }
  let(:third_answer) { create(:answer, question: second_question, user: invalid_user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      subject(:create_answer) do
        post :create, params: {
          question_id: question, answer: attributes_for(:answer), format: :js
        }
      end

      it 'saves the new answer in the database' do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        create_answer
        expect(response).to render_template :create
      end

      it 'saves the new answer in the database with valid user' do
        expect { create_answer }.to change(user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      sign_in_user

      subject(:create_invalid_answer) do
        post :create, params: {
          answer: attributes_for(:invalid_answer), question_id: question, format: :js
        }
      end

      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        create_invalid_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid best answer' do
      sign_in_user

      subject(:create_invalid_best_answer) do
        post :create, params: {
          answer: { body: 'my new body', best_answer: true }, question_id: question, format: :js
        }
      end

      it 'saves the answer with best_answer equals false' do
        create_invalid_best_answer
        expect(Answer.first.best_answer).to eq false
      end

      it 'renders create template' do
        create_invalid_best_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before do
      answer
      second_answer
    end

    context 'valid user' do
      it 'deletes answer' do
        expect {
          delete :destroy, params: { question_id: question, id: answer, format: :js }
          }.to change(Answer, :count).by(-1)
      end

      it 'renders update template' do
        delete :destroy, params: { id: answer, question_id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'invalid user' do
      it 'can not delete answer' do
        expect {
          delete :destroy, params: { id: second_answer, question_id: question, format: :js }
          }.to_not change(Answer, :count)
      end

      it 'renders update template' do
        delete :destroy, params: { id: second_answer, question_id: question, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      sign_in_user
      before do
        answer
        second_answer
      end
      subject(:update_answer) do
          patch :update, params: {
            id: answer, question_id: question, answer: attributes_for(:answer), format: :js
          }
      end

      it 'assings the requested answer to @answer' do
        update_answer
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        update_answer
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: {
          id: answer, question_id: question, answer: { body: 'my new body'}, format: :js
        }
        answer.reload
        expect(answer.body).to eq 'my new body'
      end

      it 'renders update template' do
        update_answer
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      before { third_answer }
      subject(:update_answer_with_invalid_attributes) do
          patch :update, params: {
            id: third_answer, question_id: second_question,
            answer: attributes_for(:invalid_answer), format: :js
          }
      end

      it 'does not change body of answer' do
        update_answer_with_invalid_attributes
        third_answer.reload
        expect(third_answer.body).to_not eq nil
      end

      it 'renders update template' do
        update_answer_with_invalid_attributes
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #make_best' do
    context 'with valid attributes' do
      sign_in_user
      before do
        answer
        second_answer
      end
      subject(:make_answer_best) do
        patch :make_best, params: {
          id: answer, question_id: question,
          answer: { best_answer: true }, format: :js
        }
      end

      it 'assings the requested answer to @answer' do
        make_answer_best
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns the question' do
        make_answer_best
        expect(assigns(:question)).to eq question
      end

      it 'changes best_answer to true' do
        make_answer_best
        answer.reload

        expect(answer.best_answer).to eq true

        patch :make_best, params: {
          id: second_answer, question_id: question,
          answer: { best_answer: true }, format: :js
        }
        answer.reload
        second_answer.reload

        expect(answer.best_answer).to eq false
        expect(second_answer.best_answer).to eq true
      end

      it 'renders make_best template' do
        make_answer_best
        expect(response).to render_template :make_best
      end
    end

    context 'with invalid attributes' do
      sign_in_user
      before { third_answer }
      subject(:make_answer_best_with_invalid_attributes) do
          patch :make_best, params: {
            id: third_answer, question_id: second_question,
            answer: { body: 'my new body', best_answer: true }, format: :js
          }
      end

      it 'does not change body of answer' do
        make_answer_best_with_invalid_attributes
        third_answer.reload
        expect(third_answer.body).to_not eq nil
      end

      it 'does not change best_answer to true' do
        make_answer_best_with_invalid_attributes
        third_answer.reload
        expect(third_answer.best_answer).to eq false
      end

      it 'renders make_best template' do
        make_answer_best_with_invalid_attributes
        expect(response).to render_template :make_best
      end
    end
  end

  describe 'POST #vote_for' do
    sign_in_user

    it "increases rating of other user's answer" do
      expect {
        post :vote_for, params: { question_id: question, id: second_answer, format: :js }
        }.to change(second_answer, :rating).by(1)
    end

    it "does not change rating of current user's answer" do
      expect {
        post :vote_for, params: { question_id: question, id: answer, format: :js }
        }.to_not change(second_answer, :rating)
    end
  end

  describe 'POST #vote_against' do
    sign_in_user

    it "decreases rating of other user's answer" do
      expect {
        post :vote_against, params: { question_id: question, id: second_answer, format: :js }
        }.to change(second_answer, :rating).by(-1)
    end

    it "does not change rating of current user's answer" do
      expect {
        post :vote_against, params: { question_id: question, id: answer, format: :js }
        }.to_not change(second_answer, :rating)
    end
  end

  describe 'POST #reset_vote' do
    sign_in_user
    before {  post :vote_for, params: { question_id: question, id: second_answer } }

    it "changes rating of other user's answer to 0" do
      expect {
        post :reset_vote, params: { question_id: question, id: second_answer, format: :js }
        }.to change(second_answer, :rating).by(-1)
    end

    it "does not change rating of current user's answer" do
      expect {
        post :reset_vote, params: { question_id: question, id: answer, format: :js }
        }.to_not change(second_answer, :rating)
    end
  end
end
