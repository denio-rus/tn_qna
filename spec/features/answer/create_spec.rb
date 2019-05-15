require 'rails_helper'

feature 'Only authenticated user can create answers', %q{
  In order to provide assistance
  As an authenticated user
  I'd like be able to write answer to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) } 
  
  describe 'An authenticated user', js: true do 
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes answer to the question' do 
      fill_in 'Your answer', with: 'My answer!'
      click_on 'Save answer'

      expect(page).to have_content 'Your answer was saved successfully!'
      expect(page).to have_content 'My answer!'
    end
  
    scenario 'writes answer to the question with errors' do 
      click_on 'Save answer'

      expect(page).to have_content "Answer wasn't saved"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'An unauthenticated user tries to write answer to the question' do 
    visit question_path(question)
    
    within '.new-answer' do
      fill_in 'Your answer', with: 'My answer!'
      click_on 'Save answer' 
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end