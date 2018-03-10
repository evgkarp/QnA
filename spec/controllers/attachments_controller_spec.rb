require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { @user || create(:user) }
  let(:question) { create(:question, user: user) }
  let(:attachment) { create(:attachment, attachable: question) }
  let(:invalid_user) { create(:user) }
  let(:second_question) { create(:question, user: invalid_user) }
  let(:second_attachment) { create(:attachment, attachable: second_question) }

  describe 'DELETE #destroy' do
    context 'valid user' do
      sign_in_user
      before do
        question
        attachment
      end
      it 'deletes attachment' do
        expect {
          delete :destroy, params: { question_id: question, id: attachment }, format: :js
          }.to change(Attachment, :count).by(-1)
      end
    end

    context 'unauthenticated user' do
      before do
        question
        attachment
      end
      it 'deletes attachment' do
        expect {
          delete :destroy, params: { question_id: question, id: attachment }, format: :js
          }.not_to change(Attachment, :count)
      end
    end

    context "user deletes attachment from other user's question" do
      sign_in_user
      before do
        second_question
        second_attachment
      end
      it 'deletes attachment' do
        expect {
          delete :destroy, params: { question_id: second_question, id: second_attachment
            }, format: :js }.not_to change(Attachment, :count)
      end
    end
  end
end
