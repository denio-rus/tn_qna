require 'rails_helper'

feature 'User can add comments to a question', %q{
  In order to add remarks and viewpoints to a question 
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'an authenticated user' do
    scenario 'adds comment to the question' do
      sign_in(user)
      visit question_path(question)
      
      within('.question') do
        click_on 'add comment'
        fill_in "Comment", with: 'My awesome comment'
        click_on 'Save comment'

        expect(page).to have_content 'My awesome comment'
      end
    end
  end

  describe 'An unauthenticated user'
end
