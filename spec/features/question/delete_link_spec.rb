require 'rails_helper'

feature 'User can delete links in question', %q{
  In order to remove  wrong  info in my question 
  As an author of the question
  I'd like to be able to delete links
} do
  given(:link) { create(:link, :for_question) }

  describe 'An authenticated user' do
    given(:user) { create(:user) }

    scenario 'As author of the question deletes links from the question', js: true do
      sign_in(link.linkable.author)
      visit question_path(link.linkable)
      
      within '.question' do
        click_on 'Delete link'

        expect(page).to_not have_link link.url
      end
    end

    scenario "tries to delete link in another user's question" do
      sign_in(user)
      visit question_path(link.linkable)

      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'An unauthenticated user tries to delete link in question' do
    visit question_path(link.linkable)

    expect(page).to_not have_link 'Delete link'    
  end
end