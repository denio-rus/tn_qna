require 'rails_helper'

feature 'View all answers to the question on the page showing the question', %q{
  In order to find solution
  As an user
  I'd like to be able to see all answers to the question on one page'
} do
  given(:question) { create(:question_with_answers, answers_count: 8) }
  
  scenario 'User views all answers to the questions' do
    visit question_path(question)

    question.answers.each { |answer| expect(page).to have_content answer.body } 
  end
end