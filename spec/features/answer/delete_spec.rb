require 'rails_helper'

feature 'Only author can delete the answer', %q{
  In order to remove my incorrect or not smart answers
  As an author of the answer
  I'd like to be able to delete my answer
} do

  given(:answer) { create(:answer) }

  describe 'An authenticated user' do
    given(:user) { create(:user) }

    scenario 'deletes his answer' do
      sign_in(answer.author) 

      visit question_path(answer.question)
      click_on 'Delete answer'

      expect(page).to_not have_content "MyText-Answer"
    end

    scenario 'tries to delete an answer of another user' do 
      sign_in(user)
      
      visit question_path(answer.question)
      click_on 'Delete answer'

      expect(page).to have_content "MyText-Answer"
    end
  end

  scenario 'An unauthenticated user tries to delete an any answer' do 
    visit question_path(answer.question)
    click_on 'Delete answer'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
