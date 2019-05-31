require 'rails_helper'

feature 'user can voting for best and worst answers', %q{
  In order to choose best answers
  As an authenticated user
  I'd like to be able to vote for best and worst answers'
} do
  given(:question) { create(:question_with_answers) }
  
  describe 'An authenticated user' do
    given(:user) { create(:user) }

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

    scenario 'votes for the worst answer'
    scenario 'unvotes'
    scenario 'tries to vote for his answer'
  end

  scenario 'An unauthenticated user tries to vote'
end