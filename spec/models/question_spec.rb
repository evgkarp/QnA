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
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:object_name) { :question }

  it_behaves_like 'Votable'

  describe '#subscribe' do
    let!(:user) { create(:user) }
    subject { build(:question, user: user) }

    it 'saves subscription for the question to db' do
      expect{ subject.save! }.to change(Subscription, :count).by(1)
    end

    it 'saves subscription to db with given question' do
      subject.save!
      expect(Subscription.last.question).to eq subject
    end

    it 'saves subscription to db with given user' do
      subject.save!
      expect(Subscription.last.user).to eq user
    end
  end
end
