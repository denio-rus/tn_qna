require 'rails_helper'

RSpec.describe Answer, type: :model do
  let (:question) { create(:question_with_answers, answers_count: 3) }

  it { should belong_to(:author).class_name('User') }
  it { should belong_to :question }

  it { should validate_presence_of :body }

  it "set the best answer to the question, it's only one" do
    question.answers.last.set_best
 
    expect(question.answers.last).to be_best
    expect(question.answers.where(best: true).count).to eq 1
  end

  it "changes the best answer" do
    question.answers.last.set_best
    question.answers.first.set_best

    expect(question.answers.first).to be_best
    expect(question.answers.last).to_not be_best
    expect(question.answers.where(best: true).count).to eq 1
  end

  it 'set the best answer to be the first one in the list' do
    question.answers.last.set_best
    expect(question.answers.best_first.first).to eq question.answers.last
  end
end
