require 'rails_helper'

feature 'Only author can delete the question', %q{
  In order to cancel requests to community for help
  As an author of the question
  I'd like to be able to delete the question
} do
  given(:question) { create(:question, title: 'test_delete_question', body: '12345') }

  describe 'An authenticated user' do
    given(:user) { create(:user) }
 
    scenario 'deletes his question' do 
      sign_in(question.author)

      visit question_path(question)
      click_on 'Delete question'

      expect(page).to_not have_content 'test_delete_question'      
    end
    
    scenario 'tries to delete a question of another user' do 
      sign_in(user)
      visit question_path(question)
      
      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'An unauthenticated user tries to delete any question' do 
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
