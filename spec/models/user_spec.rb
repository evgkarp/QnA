require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe 'author_of?' do
    let(:user) { create(:user) }
    let(:invalid_user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it 'author' do
      expect(user).to be_author_of(question)
    end

    it 'not author' do
      expect(invalid_user).not_to be_author_of(question)
    end
  end
end
