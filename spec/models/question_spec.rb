require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question_with_answers) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like 'votable'
  it_behaves_like 'linkable'
  it_behaves_like 'attachable'

  it 'returns best answer' do
    question.answers.order(id: :desc)[3].set_best
    expect(question.best_answer).to eq question.answers.order(id: :desc)[3]
  end

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) {build(:question)}

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
