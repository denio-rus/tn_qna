require 'rails_helper'

feature 'User can add links', %q{
  In order to provide additional info to my answer 
  As an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/denio-rus/e1bdd70b70726a6d5d7fc57bd490a7a2' }

  scenario 'User adds link when asks question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
  
    click_on 'Save answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end