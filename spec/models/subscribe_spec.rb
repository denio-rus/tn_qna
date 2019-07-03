require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
   
  #it { should validate_uniqueness_of(:user_id).scoped_to(:question_id) }
  it 'validates uniqueness of combination of user_id and question_id' do
    question = create(:question)
    user = create(:user)
    Subscribe.create(question: question, user: user)

    expect(Subscribe.new(question: question, user: user)).to_not be_valid
  end
end
