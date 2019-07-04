require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe "notice" do
    let(:answer) { create(:answer) }
    let(:subscription) { create(:subscription, question: answer.question) }
    let(:mail) { NewAnswerNotificationMailer.notice(subscription.user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notice")
      expect(mail.to).to eq([subscription.user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
