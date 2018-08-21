require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    context 'unauthorized' do
      let!(:question) { create(:question) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { @user || create(:user) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    context 'unauthorized' do
      let!(:answer) { create(:answer) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:user) { @user || create(:user) }
      let!(:question) { create(:question) }
      let(:answer) { create(:answer, question: question, user: user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/answers/#{answer.id}", params: {format: :json, access_token: access_token.token }}

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at user_id).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        %w(url filename).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.file.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'authorized' do
      let!(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }

      subject(:create_answer) do
        post "/api/v1/questions/#{question.id}/answers", params: { action: :create, format: :json, access_token: access_token.token, answer: attributes_for(:answer) }
      end

      it 'returns 200 status' do
        create_answer
        expect(response).to be_success
      end

      it 'saves answer to the database' do
        expect{ create_answer }.to change { Answer.count }.by(1)
      end
    end
  end
end
