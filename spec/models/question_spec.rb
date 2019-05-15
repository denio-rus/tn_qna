require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question_with_answers) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'returns best answer' do
    question.answers.order(id: :desc)[3].set_best
    expect(question.best_answer).to eq question.answers.order(id: :desc)[3]
  end
end
