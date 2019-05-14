require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question_with_answers) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'validates inclusion of best_answer to answers to the question' do
    question2 = create(:question)
    other_answer = create(:answer)

    question.best_answer_id = question.answers.ids.first
    question2.best_answer_id = other_answer.id

    expect(question).to be_valid
    expect(question2).to_not be_valid
  end

  it 'shows best answer as the first item in the list of answers' do 
    question.best_answer_id = question.answers.order(id: :desc).ids[4]
    expect(question.ordered_answers.first).to eq question.answers.order(id: :desc)[4]
  end

  it 'returns best answer' do
    question.best_answer_id = question.answers.order(id: :desc).first.id
    expect(question.best_answer).to eq question.answers.order(id: :desc).first
  end
end
