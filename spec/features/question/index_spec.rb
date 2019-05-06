require 'rails_helper'

feature 'User can view the list of all questions', %q{ 
  In order to find interesting question
  As an any user
  I'd like to be able to see the list of all questions
} do
  scenario 'User views questions' do 
    questions = create_list(:question, 8)

    visit questions_path
    
    questions.each { |question| expect(page).to have_content question.title }
  end
end