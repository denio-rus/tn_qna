require 'rails_helper'

feature 'User can view the list of all questions', %q{ 
  In order to find interesting question
  As an any user
  I'd like to be able to see the list of all questions
} do
  given(:user) { create(:user) }

  scenario 'User views questions' do 
    Question.create(title: "question 1", body: "text", author: user)
    Question.create(title: "question 2", body: "text", author: user)

    visit questions_path
    
    expect(page).to have_content "question 1"
    expect(page).to have_content "question 2"
  end
end