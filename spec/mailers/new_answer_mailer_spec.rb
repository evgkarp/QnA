require "rails_helper"

RSpec.describe NewAnswerMailer, type: :mailer do
  describe "notification" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NewAnswerMailer.notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end

    it "contains body of answer that was just created" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end
