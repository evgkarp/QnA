require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  let(:comment) { create(:comment, user: user)}

  describe 'POST #create' do
    context 'with valid attributes' do
      sign_in_user

      it 'saves the new comment in the database' do
        expect { post :create, params: {
          question_id: question, format: :js, comment: attributes_for(:comment) }
          }.to change(question.comments, :count).by(1)

        expect { post :create, params: {
          answer_id: answer, question_id: question, format: :js, comment: attributes_for(:comment) }
          }.to change(answer.comments, :count).by(1)
      end

      it 'saves the new comment in the database with valid user' do
        expect { post :create, params: {
          question_id: question, format: :js, comment: attributes_for(:comment) }
          }.to change(user.comments, :count).by(1)
      end
    end
  end
end
