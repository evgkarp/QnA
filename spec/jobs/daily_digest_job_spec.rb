require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let!(:users){ create_list(:user, 2) }
  let!(:questions){ create_list(:question, 2, user: users.first)}
  it 'sends daily digest' do
    users.each do |user|
      expect(DailyMailer).to receive(:digest).with(user)
    end
    DailyDigestJob.perform_now
  end
end
