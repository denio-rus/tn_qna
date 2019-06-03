require 'rails_helper'

feature 'User can add links', %q{
  In order to provide additional info to my answer 
  As an author of the answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/denio-rus/e1bdd70b70726a6d5d7fc57bd490a7a2' }
  given(:answer) { create(:answer, question: question) }

  scenario 'User adds links when answers the question', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'Answer text text text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'
    
    within all('.nested-fields').last do 
      all('.field input').first.fill_in with: 'yandex' 
      all('.field input').last.fill_in with: 'http://yandex.ru'
    end
  
    click_on 'Save answer'

    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'My gist', href: gist_url
      expect(page).to have_link 'yandex', href: 'http://yandex.ru'
      expect(page).to have_content 'gist_for_test.txt'
      expect(page).to have_content "It's a test gist."
    end
  end

  scenario 'User add links to persisted answer (on edit)', js: true do
    sign_in(answer.author)
    visit question_path(question)

    within ('.answers') do
      click_on 'Edit'
      click_on 'Add link'
      
      fill_in 'Link name', with: 'yandex'
      fill_in 'Url', with: 'http://yandex.ru'

      click_on 'Save'

      expect(page).to have_link 'yandex', href: 'http://yandex.ru'
    end
  end
end
