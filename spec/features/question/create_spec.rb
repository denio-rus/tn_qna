require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  
  describe 'Authenticated user' do 
    background do 
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do 
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'
  
      expect(page).to have_content 'Your question successfully created'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with attached file' do 
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with reward' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
  
      fill_in 'Reward', with: 'Grand Prix'
      attach_file 'Image', "#{Rails.root}/app/assets/images/cup.jpg"
  
      click_on 'Ask'
  
      expect(page).to have_content 'Grand Prix'
      expect(page).to have_css "img[src*='cup.jpg']"
    end
  
    scenario 'asks a question with errors' do 
      click_on 'Ask'
  
      expect(page).to have_content "Title can't be blank"
    end
  end

  fcontext 'multiple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'
        
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Unauthenticatad user tries to ask a question' do 
    visit questions_path

    expect(page).to_not have_link 'Ask question'
  end
end
