require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:question) { create(:question_with_answers, answers_count: 3) }

  it { should belong_to(:author).class_name('User') }
  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }
  
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'

  it "set the best answer to the question, it's only one" do
    question.answers.last.set_best
 
    expect(question.answers.last).to be_best
    expect(question.answers.where(best: true).count).to eq 1
  end

  it "changes the best answer" do
    create(:reward, question: question)
    question.answers.last.set_best
    question.answers.first.set_best

    expect(question.answers.first).to be_best
    expect(question.answers.last).to_not be_best
    expect(question.answers.where(best: true).count).to eq 1
    expect(question.reward.user).to eq question.answers.first.author
  end

  it 'sets the best answer to be the first one in the list' do
    question.answers.last.set_best
    expect(question.answers.best_first.first).to eq question.answers.last
  end

  it 'have many atteched files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
