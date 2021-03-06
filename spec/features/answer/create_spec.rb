require 'rails_helper'

feature 'Only authenticated user can create answers', %q{
  In order to provide assistance
  As an authenticated user
  I'd like be able to write answer to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers) } 
  
  describe 'An authenticated user', js: true do 
    background do 
      sign_in(user)
      visit question_path(question)
    end

    scenario 'writes answer to the question' do 
      fill_in 'Your answer', with: 'My answer!'
      click_on 'Save answer'

      expect(page).to have_content 'My answer!'
    end

    scenario 'gives an answer with attached file' do
      fill_in 'Your answer', with: 'My answer!'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Save answer'
      
      sleep 0.5
      visit question_path(question)

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  
    scenario 'writes answer to the question with errors' do 
      click_on 'Save answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'An unauthenticated user tries to write answer to the question' do 
    visit question_path(question)
    
    within '.new-answer' do
      fill_in 'Your answer', with: 'My answer!'
      click_on 'Save answer' 
    end

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
  
  fcontext 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end
  
      Capybara.using_session('guest') do
        visit question_path(question)
      end
  
      Capybara.using_session('user') do
        within('.new-answer') do
          fill_in 'Your answer', with: 'My answer!'
          click_on 'Save answer'
        end
  
        expect(page).to have_content 'My answer!'
      end
  
      Capybara.using_session('guest') do
        expect(page).to have_content 'My answer!'
      end
    end
  end
end
