require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should have_db_column(:question_id) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_db_column(:best_answer) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  describe 'votable' do
    let(:user) { @user || create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'should create new vote with vote_for' do
      expect { answer.vote_for(user) }.to change(Vote, :count).by(1)
    end

    it 'should create new vote with vote_against' do
      expect { answer.vote_against(user) }.to change(Vote, :count).by(1)
    end

    it 'should set rating to 1' do
      answer.vote_for(user)
      expect(answer.rating).to eq 1
    end

    it 'should set rating to -1' do
      answer.vote_against(user)
      expect(answer.rating).to eq -1
    end

    it 'should check does answer have vote?' do
      answer.vote_for(user)
      expect(answer.has_vote?(user)).to eq true
    end

    it 'should get a sum of votes' do
      answer.vote_for(user)
      expect(answer.rating).to eq 1
    end

    it 'should reset point by removing record for this vote' do
      answer.vote_for(user)
      expect { answer.reset_vote(user) }.to change(Vote, :count).by(-1)
    end
  end
end
