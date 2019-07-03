require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }

  it 'sends notification to author of the question' do 
    expect(NewAnswerNotificationMailer).to receive(:notice).with(user, answer).and_call_original 
    subject.notice(answer)
  end

  it 'sends notifications to all subscribers' do 
    create_list(:subscribe, 3, question: question)
    question.subscribers.each { |user| expect(NewAnswerNotificationMailer).to receive(:notice).with(user, answer).and_call_original }
    subject.notice(answer)
  end  

  it 'sends notification to all subscribers(including author) of the question' do 
    create_list(:subscribe, 3, question: question)
    expect(NewAnswerNotificationMailer).to receive(:notice).exactly(4).times.and_call_original 
    subject.notice(answer)
  end
end