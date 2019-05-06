require 'rails_helper'

feature 'User can write the answer on the page showing the question', %q{
  In order to give help
  as an user 
  I'd like to be able to write answer
} do 
  given(:question) { create(:question) }

  scenario 'User can write the answer on the page showing question' do
    visit question_path(question)

    expect(page).to have_field('Your answer:', type: 'textarea')
    expect(page).to have_button('Save answer')
  end
end