require 'rails_helper'

feature 'User can register', %q{
  In order to get access to creation of questions or answers
  As an unauthenticated user
  I'd like to be able to register'
} do
  describe 'Unauthenticated user' do
    background do
      visit new_user_registration_path
      fill_in 'Email', with: 'test_user@email.com'
      fill_in 'user_password', with: '12345678'
    end
    
    scenario 'registers in the system' do
      fill_in 'user_password_confirmation', with: '12345678'
      click_on 'Sign up'

      open_email 'test_user@email.com'
      current_email.click_link 'Confirm my account'

      visit root_path
      click_on 'Sign in'

      fill_in 'Email', with: 'test_user@email.com'
      fill_in 'user_password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content "Signed in successfully."
    end

    scenario 'tries to register with errors' do 
      fill_in 'user_password_confirmation', with: '2222222'
      click_on 'Sign up'

      expect(page).to_not have_content "Signed in successfully."
    end
  end
end