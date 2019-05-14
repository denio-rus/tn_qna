require 'rails_helper'

feature 'Author of the question can choose the best answer', %q{
  In order to 
  As an author of the question
  I'd like to be able to choose the best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, author: user) }
  given(:other_user_question) { create(:question) }

  describe 'An authenticated user',  js: true do
    background { sign_in user }

    scenario 'chooses the best answer for his question' do
      best = create(:answer, body: '!!best answer!!', question: question)
      visit question_path(question)

      within ".answer-#{best.id}" do
        click_on 'Make it the best answer'
      end

      sleep 0.5
      expect(page.find('.answers p', match: :first).text).to eq '!!best answer!!'
    end

    scenario 'tries to choose the best answer to a question of another user' do 
      visit question_path(other_user_question)

      expect(page).to_not have_content 'Make it the best answer'
    end
  end

  scenario 'An unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Make it the best answer'
  end
end