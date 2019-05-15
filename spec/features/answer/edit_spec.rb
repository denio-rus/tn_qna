require 'rails_helper'

feature 'User can edit his answers', %q{
  In order to correct mistaces
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  
  
  scenario 'Unauthenticated user can not edit answer'  do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background { sign_in user }

    scenario 'edits his answer'do 
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

    scenario 'tries to edit his answer with errors' do
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in "Your answer:", with: ''
        click_on 'Save'
      end

      expect(page).to have_content answer.body
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      question = create(:question_with_answers)
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end
