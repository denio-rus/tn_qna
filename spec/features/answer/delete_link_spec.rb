require 'rails_helper'

feature 'User can delete links in answer', %q{
  In order to remove  wrong info in my answer 
  As an author of the answer
  I'd like to be able to delete links
} do
  given(:link) { create(:link, :for_answer) }

  describe 'An authenticated user' do
    given(:user) { create(:user) }

    scenario 'As author of the answer deletes links from the answer', js: true do
      sign_in(link.linkable.author)
      visit question_path(link.linkable.question)
      
      within '.answers' do
        click_on 'Delete link'

        expect(page).to_not have_link link.url
      end
    end

    scenario "tries to delete link in another user's answer" do
      sign_in(user)
      visit question_path(link.linkable.question)

      expect(page).to_not have_link 'Delete link'
    end
  end

  scenario 'An unauthenticated user tries to delete link in answer' do
    visit question_path(link.linkable.question)

    expect(page).to_not have_link 'Delete link'    
  end
end