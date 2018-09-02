require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:user){ create(:user) }
  let(:non_subscribed_users) { create_list(:user, 2) }
  let(:question) { create(:question, user: user)}
  let!(:subscribed_users) { create_list(:user, 2) }

  let!(:answer){ create(:answer,question: question, user: user) }
  it 'sends new answer notification to subscribed user' do
    subscribed_users.each do |subscribed_user|
      subscribed_user.add_subscription(question)
      expect(NewAnswerMailer).to receive(:notification).with(subscribed_user, answer)
    end
    NewAnswerJob.perform_now(answer)
  end

  it 'does not send new answer notification to non-subscribed users' do
    non_subscribed_users.each do |non_subscribed_user|
      expect(NewAnswerMailer).to_not receive(:notification).with(non_subscribed_user, answer)
    end

    NewAnswerJob.perform_now(answer)
  end
end
