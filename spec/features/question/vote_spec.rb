require 'rails_helper'

feature 'user can voting for best and worst questions', %q{
  In order to choose best questions
  As an authenticated user
  I'd like to be able to vote for best and worst questions'
} do
  given(:question) { create(:question) }
  
  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    given(:user_question) { create(:question, author: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for the best question' do
      within(".question") do
        click_on('Like')

        expect(page).to have_content 'rating: 1'
      end
    end

    scenario 'votes for the worst question' do
      within(".question") do
        click_on('Dislike')

        expect(page).to have_content 'rating: -1'
      end
    end

    scenario 'unvotes' do
      within(".question") do
        click_on('Like')
        click_on('Unvote')

        expect(page).to have_content 'rating: 0'
      end
    end

    scenario 'tries to vote for his question' do
      user_question
      visit question_path(user_question)

      within(".question") do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to_not have_link 'Unvote'
      end
    end
  end

  scenario 'An unauthenticated user tries to vote' do
    visit question_path(question)
    within(".question") do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
      expect(page).to_not have_link 'Unvote'
    end
  end
end