require 'rails_helper'

feature 'User can edit his questions', %q{
  In order to correct mistaces
  As an author of answer
  I'd like to be able to edit my question
} do
  given(:question) { create(:question) }

  scenario 'Unauthenticated user can not edit question'  do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }
    given(:question) { create(:question, author: user) }

    background { sign_in user }

    scenario 'edits his question' do 
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do 
        fill_in "Title", with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
        expect(page).to_not have_selector 'input'
      end
    end 

    scenario 'tries to edit his question with errors' do
      visit question_path(question)

      click_on 'Edit question'

      within '.question' do
        fill_in "Title", with: ''
        fill_in "Body", with: ''
        click_on 'Save'
      end

      expect(page).to have_content question.title
      expect(page).to have_content question.body
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      question = create(:question)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end