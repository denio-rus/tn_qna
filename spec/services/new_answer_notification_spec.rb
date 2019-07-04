require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  ActiveJob::Base.queue_adapter = :test
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:not_subscribed_user) { create(:user) }

  it 'sends notification to author of the question' do 
    expect(NewAnswerNotificationMailer).to receive(:notice).with(question.author, answer).and_call_original 
    subject.notice(answer)
  end

  it 'sends notification to all subscribers(including author) of the question' do 
    create_list(:subscription, 3, question: question)

    question.subscribers.each { |user| expect(NewAnswerNotificationMailer).to receive(:notice).with(user, answer).and_call_original }
    subject.notice(answer)
    expect(NewAnswerNotificationMailer).to receive(:notice).exactly(4).times.and_call_original
    subject.notice(answer)
  end  

  it 'does not send notification to not subscribed user' do 
    expect(NewAnswerNotificationMailer).to_not receive(:notice).with(not_subscribed_user, answer)
    subject.notice(answer)
  end  
end
