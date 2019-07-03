require 'rails_helper'

feature "User can get 'new answer notifications'", %q{
  In order to speed up the receipt of information 
  As an authenticated user
  I'd like to be able to receive notification about new answers to the question
} do
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given(:user) { create(:user) }
  given(:answer) { create(:answer, question: question) }
  
  before { NewAnswerNotificationJob.perform_now(answer) }

  scenario 'An author' do
    open_email author.email

    expect(current_email).to have_content 'My answer!'
    current_email.click_link question.title

    #expect(page).to eq page(question_path(question))
  end
end