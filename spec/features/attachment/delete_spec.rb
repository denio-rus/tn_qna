require 'rails_helper'

feature 'User can delete files attached', %q{
  In order to remove unnecessary files 
  As an author of the question or the answer
  I'd like to be able to delete attached files
} do
  given(:question) { create(:question_with_attached_file) }
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

    scenario "tries to delete files attached to another user's answer" do
      sign_in user
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link answer.files.first.filename.to_s
        expect(page).to_not have_link 'Delete file'
      end
    end

    scenario 'as an author of the question deletes attached file' do
      sign_in question.author
      visit question_path(question)

      within '.question' do
        click_on 'Delete file'

        expect(page).to_not have_link question.files.first.filename.to_s
      end
    end

    scenario "tries to delete files attached to another user's question" do
      sign_in user
      visit question_path(question)

      within '.question' do
        expect(page).to have_link question.files.first.filename.to_s
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'An unauthenticated user' do
    scenario 'tries to delete attached files' do
      visit question_path(question, answer: answer)
      
      expect(page).to_not have_link 'Delete file'
    end
  end
end