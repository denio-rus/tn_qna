require 'rails_helper'

feature 'User can authenticate with some third-party account', %q{
  In order to get access to creation of questions or answers
  As an unauthenticated user
  I'd like to be able to authenticate with some third-party account'
} do
  background { Rails.application.env_config["devise.mapping"] = Devise.mappings[:user] }

  describe "vkontakte" do
    after { OmniAuth.config.mock_auth[:vkontakte] = nil }

    it "can sign in user with Vk account" do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte]
      visit root_path
      click_on 'Sign in'
      mock_auth_hash
      click_link "Sign in with Vkontakte"

      expect(page).to have_content "Successfully authenticated from Vkontakte account."
      expect(page).to have_content "Sign out"
    end

    it "can sign in user with Vk account without email given from provider" do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte_no_mail] 

      visit root_path
      click_on 'Sign in'
      click_link "Sign in with Vkontakte"
      expect(page).to have_content "We need email to continue, please, enter your email for registration"

      fill_in 'Email', with: 'user@mail.com'
      click_on 'Sign up'

      open_email 'user@mail.com'
      current_email.click_link 'Confirm my account'
      expect(page).to have_content "Your email address has been successfully confirmed."
      
      click_on "Sign in with Vkontakte"

      expect(page).to have_content "Successfully authenticated from Vkontakte account."
      expect(page).to have_content "Sign out"
    end
    
    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit root_path
      click_on 'Sign in'
      click_on "Sign in with Vkontakte"

      expect(page).to have_content 'Invalid credentials'
      expect(page).to_not have_content "Sign out"
    end
  end

  describe "github" do
    after { OmniAuth.config.mock_auth[:github] = nil }

    it "can sign in user with GitHub account" do
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      visit root_path
      click_on 'Sign in'
      mock_auth_hash
      click_link "Sign in with GitHub"

      expect(page).to have_content "Successfully authenticated from Github account."
      expect(page).to have_content "Sign out"
    end
    
    it "can handle authentication error" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit root_path
      click_on 'Sign in'
      click_on "Sign in with GitHub"

      expect(page).to have_content 'Invalid credentials'
      expect(page).to_not have_content "Sign out"
    end
  end
end