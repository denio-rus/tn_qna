require 'rails_helper'

feature 'User can add comments to a question', %q{
  In order to add remarks and viewpoints to a question 
  As an authenticated user
  I'd like to be able to add comments
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'an authenticated user', js: true do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds comment to the question' do
      within('.question') do
        click_on 'Add comment'
        fill_in "Your comment", with: 'My awesome comment'
        click_on 'Save comment'

        expect(page).to have_content 'My awesome comment'
      end
    end

    scenario 'adds comment to the question with errors' do
      within('.question') do
        click_on 'Add comment'
        click_on 'Save comment'

        expect(page).to have_content "Body can't be blank"
        expect(page).to_not have_content 'My awesome comment'
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within('.question') do
          click_on 'Add comment'
          fill_in "Your comment", with: 'My awesome comment'
          click_on 'Save comment'
  
          expect(page).to have_content 'My awesome comment'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My awesome comment'
      end
    end
  end

  describe 'An unauthenticated user' do 
    scenario 'tries to add comment to question' do 
      visit question_path(question)
      expect(page).to_not have_content 'Add comment'
    end
  end

end
