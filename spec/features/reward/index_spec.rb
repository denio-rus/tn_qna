require 'rails_helper'

feature 'User can get a reward for the best answer', %q{
  In order to encourage members of community
  As an author of answers
  I'd like to be able to list my rewards
} do
  given!(:reward) { create(:reward, title: 'Special') }
  given!(:answer) { create(:answer, question: reward.question) }

  scenario 'gives reward to the best answer', js: true do
    sign_in(reward.question.author)
    visit question_path(reward.question)

    click_on 'Make it the best answer'
    click_on 'Sign out'

    sign_in(answer.author)
    visit rewards_path

    expect(page).to have_content 'Special'
    expect(page).to have_content answer.question.title
    expect(page).to have_css "img[src*='cup.jpg']"
  end
end