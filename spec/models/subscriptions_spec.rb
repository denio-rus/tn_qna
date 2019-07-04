require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
   
  it 'validates uniqueness of combination of user_id and question_id' do
    question = create(:question)
    user = create(:user)
    Subscription.create(question: question, user: user)

    expect(Subscription.new(question: question, user: user)).to_not be_valid
  end
end
