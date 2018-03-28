require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_least(10) }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_many(:votes).dependent(:destroy) }

  describe 'votable' do
    let(:user) { @user || create(:user) }
    let(:question) { create(:question, user: user) }

    it 'should create new vote with vote_for' do
      expect { question.vote_for(user) }.to change(Vote, :count).by(1)
    end

    it 'should create new vote with vote_against' do
      expect { question.vote_against(user) }.to change(Vote, :count).by(1)
    end

    it 'should set rating to 1' do
      question.vote_for(user)
      expect(question.rating).to eq 1
    end

    it 'should set rating to -1' do
      question.vote_against(user)
      expect(question.rating).to eq -1
    end

    it 'should check does question have vote?' do
      question.vote_for(user)
      expect(question.has_vote?(user)).to eq true
    end

    it 'should get a sum of votes' do
      question.vote_for(user)
      expect(question.rating).to eq 1
    end

    it 'should reset point by removing record for this vote' do
      question.vote_for(user)
      expect { question.reset_vote(user) }.to change(Vote, :count).by(-1)
    end
  end
end
