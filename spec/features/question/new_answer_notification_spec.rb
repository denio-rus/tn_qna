require 'rails_helper'

feature "User can get 'new answer notifications'", %q{
  In order to speed up the receipt of information 
  As an authenticated user
  I'd like to be able to receive notification about new answers to the question
} do
  ActiveJob::Base.queue_adapter = :test
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  context "Authorized user" do
    scenario 'creates answer', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'My answer!'
      expect { 
        click_on 'Save answer'
        sleep 0.3
        }.to have_enqueued_job(NewAnswerNotificationJob)
    end

    scenario 'subscribes' do
      sign_in(user)
      visit question_path(question)

      within('.subscribe') do
        expect(page).to_not have_link 'Unsubscribe'

        click_on "Subscribe"

        expect(question.subscribers.ids).to be_include question.user_id
        expect(page).to have_link 'Unsubscribe'
      end
    end
  end

  context "an author of the question" do
    scenario 'unsubscribes' do
      sign_in(question.author)
      visit question_path(question)
      within('.subscribe') do
        expect(page).to_not have_link 'Subscribe'
  
        click_on "Unsubscribe"
  
        expect(question.subscribers.ids).to_not be_include question.user_id
        expect(page).to have_link 'Subscribe'
      end
    end
  end
end
