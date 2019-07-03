require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:answer) { create(:answer) }

  it 'sends notification to author of the question' do 
    expect(NewAnswerNotificationMailer).to receive(:notice).with(answer).and_call_original 
    subject.notice(answer)
  end
end