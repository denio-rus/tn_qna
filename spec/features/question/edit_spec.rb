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

    background { sign_in user }
    
    describe 'as an author' do 
      given(:question) { create(:question, author: user) }

      background do
        visit question_path(question)
        click_on 'Edit question'
      end
    
      scenario "edits his question's title and body" do 
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
  
      scenario 'attaches files to his question' do
        within '.question' do 
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
  
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
  
      scenario 'tries to edit his question with errors' do
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
    end

    scenario "tries to edit other user's question" do
      question = create(:question)
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end