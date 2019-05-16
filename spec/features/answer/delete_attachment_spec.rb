require 'rails_helper'

feature 'User can delete files attached to his answer', %q{
  In order to remove unnecessary files 
  As an author of the answer
  I'd like to be able to delete attached files
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer_with_attached_file, question: question) }
  given(:user) { create(:user) }

  describe 'An authenticated user', js: true do
    scenario 'as an author of the answer deletes attached file' do
      sign_in answer.author
      visit question_path(question)

      within '.answers' do
        click_on 'Delete file'

        expect(page).to_not have_link answer.files.first.filename.to_s
      end
    end

    scenario "tries to delete another user's question" do
      sign_in user
      visit question_path(question)

      expect(page).to have_link answer.files.first.filename.to_s
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