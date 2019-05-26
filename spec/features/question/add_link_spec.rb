require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question 
  As an author of the question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  #GIST filename: 'gist_for_test.txt', content: "It's a test gist."
  given(:gist_url) { 'https://gist.github.com/denio-rus/e1bdd70b70726a6d5d7fc57bd490a7a2' } 

  describe 'An authenticated user', js: true do
    given(:question) { create(:question) }

    scenario 'adds links when asks question (on create)' do
      sign_in(user)
      visit new_question_path
  
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      
      click_on 'Add link'
  
      within all('.nested-fields').last do 
        all('.field input').first.fill_in with: 'yandex' 
        all('.field input').last.fill_in with: 'http://yandex.ru'
      end
  
      click_on 'Ask'
  
      expect(page).to_not have_link 'My gist', href: gist_url
      expect(page).to have_link 'yandex', href: 'http://yandex.ru'
      expect(page).to have_content 'gist_for_test.txt'
      expect(page).to have_content "It's a test gist."
    end

    scenario 'add links to persisted question (on edit)' do
      sign_in(question.author)
      visit question_path(question)

      click_on 'Edit question'
      
      within ('.question') do
        fill_in 'Link name', with: 'yandex'
        fill_in 'Url', with: 'http://yandex.ru'

        click_on 'Save'

        expect(page).to have_link 'yandex', href: 'http://yandex.ru'
      end
    end
  end
end