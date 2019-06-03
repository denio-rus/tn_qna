require 'rails_helper'

feature 'user can voting for best and worst answers', %q{
  In order to choose best answers
  As an authenticated user
  I'd like to be able to vote for best and worst answers'
} do
  given(:question) { create(:question_with_answers) }
  
  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    given(:user_answer) { create(:answer, question: question, author: user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for the best answer' do
      liked_answer = question.answers.last

      within(".answer-#{liked_answer.id}") do
        click_on('Like')

        expect(page).to have_content 'rating: 1'
      end
    end

    scenario 'votes for the worst answer' do
      disliked_answer = question.answers.last

      within(".answer-#{disliked_answer.id}") do
        click_on('Dislike')

        expect(page).to have_content 'rating: -1'
      end
    end

    scenario 'unvotes' do
      liked_answer = question.answers.last

      within(".answer-#{liked_answer.id}") do
        click_on('Like')

        click_on('Unvote')
        expect(page).to have_content 'rating: 0'
      end
    end

    scenario 'tries to vote for his answer' do
      user_answer
      visit question_path(question)

      within(".answer-#{user_answer.id}") do
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_link 'Dislike'
        expect(page).to_not have_link 'Unvote'
      end
    end
  end

  scenario 'An unauthenticated user tries to vote' do
    visit question_path(question)
    within(".answers") do
      expect(page).to_not have_link 'Like'
      expect(page).to_not have_link 'Dislike'
      expect(page).to_not have_link 'Unvote'
    end
  end
end