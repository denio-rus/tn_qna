require "rails_helper"

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  describe "notice" do
    let(:answer) { create(:answer) }
    let(:mail) { NewAnswerNotificationMailer.notice(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("Notice")
      expect(mail.to).to eq([answer.question.author.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
