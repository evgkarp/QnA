require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:non_author_question) { create(:question, user: other) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:non_author_answer) { create(:answer, user: other, question: question) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }

    it { should be_able_to :update, question, user: user }
    it { should_not be_able_to :update, non_author_question, user: user }

    it { should be_able_to :destroy, question, user: user }
    it { should_not be_able_to :destroy, non_author_question, user: user }

    it { should be_able_to :vote_for, non_author_question, user: user }
    it { should_not be_able_to :vote_for, question, user: user }

    it { should be_able_to :vote_against, non_author_question, user: user }
    it { should_not be_able_to :vote_against, question,  user: user }

    it { should be_able_to :reset_vote, non_author_question, user: user }
    it { should_not be_able_to :reset_vote, question, user: user }

    it { should be_able_to :create, Answer }

    it { should be_able_to :update, answer, user: user }
    it { should_not be_able_to :update, non_author_answer, user: user }

    it { should be_able_to :destroy, answer, user: user }
    it { should_not be_able_to :destroy, non_author_answer, user: user }

    it { should be_able_to :vote_for, non_author_answer, user: user }
    it { should_not be_able_to :vote_for, answer, user: user }

    it { should be_able_to :vote_against, non_author_answer, user: user }
    it { should_not be_able_to :vote_against, answer,  user: user }

    it { should be_able_to :reset_vote, non_author_answer, user: user }
    it { should_not be_able_to :reset_vote, answer, user: user }

    it { should be_able_to :make_best, non_author_answer, user: user }
    it { should_not be_able_to :make_best, create(:answer, user: other, question: non_author_question), user: user }

    it { should be_able_to :create, Comment }

    it { should be_able_to :destroy, Attachment, user: user }
  end
end
