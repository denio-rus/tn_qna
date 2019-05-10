require 'rails_helper'

feature 'User can edit his answers', %q{
  In order to correct mistaces
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user) { create(:user) }

  scenario 'Unauthenticated user can nit edit answer'  do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    scenario 'edits his answer'do 
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in "Your answer:", with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his answer with'
    scenario "tries to edit other user's question"
  end
end