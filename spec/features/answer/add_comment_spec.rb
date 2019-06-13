require 'rails_helper'

feature 'User can add comments to an answer', %q{
  In order to add remarks and viewpoints to an answer 
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  describe 'an authenticated user', js: true do
    scenario 'adds comment to the answer' do
      sign_in(user)
      visit question_path(answer.question)
      
      within(".answer-#{answer.id}") do
        click_on 'Add comment'
        fill_in "Your comment", with: 'My awesome comment'
        click_on 'Save comment'

        expect(page).to have_content 'My awesome comment'
      end
    end
  end

  describe 'An unauthenticated user' do 
    scenario 'tries to add comment to the answer' do 
      visit question_path(answer.question)
      expect(page).to_not have_content 'Add comment'
    end
  end

end
