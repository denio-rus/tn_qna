require 'rails_helper'

feature 'User can delete attached files', %q{
  In order to remove unnecessary files 
  As an author of the question
  I'd like to be able to delete attached files
} do
  given(:question) { create(:question_with_attached_file) }

  describe 'An authenticated user', js: true do
    given(:user) { create(:user) }
    scenario 'as an author of the question deletes attached file' do
      sign_in question.author
      visit question_path(question)

      within '.question' do
        click_on 'Delete file'

        expect(page).to_not have_link question.files.first.filename.to_s
      end
    end

    scenario "tries to delete another user's question" do
      sign_in user
      visit question_path(question)

      expect(page).to have_link question.files.first.filename.to_s
      expect(page).to_not have_link 'Delete file'
    end
  end

  describe 'An unauthenticated user' do
    scenario 'tries to delete files attached to the question' do
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete file'
    end
  end
end