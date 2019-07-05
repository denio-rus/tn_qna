require 'sphinx_helper'

feature 'User can search for answer', "
  In order to find needed answer
  As a User
  I'd like to be able to search for the answer
" do
  before { visit questions_path }
  
  context "Some user searches", sphinx: true, js: true do
    scenario 'for the answer' do
      answers = create_list(:answer, 2) 
      answer = create(:answer, body: 'special answer')

      ThinkingSphinx::Test.run do
        within('.search-panel') do
          fill_in "Search:", with: 'My test answer'
          select 'Answer', from: :query_object
          click_on 'Go'
        end
  
        within('.results') do
          answers.each { |answer| expect(page).to have_content answer.body }
          expect(page).to_not have_content 'special answer'
          expect(page).to_not have_content 'Test question'
        end
      end
    end

    scenario 'for the question' do
      questions =create_list(:question, 2, body: 'ZERO') 
      question = create(:question, title: 'special question') 
      ThinkingSphinx::Test.run do
        within('.search-panel') do
          fill_in "Search:", with: 'ZERO'
          select 'Question', from: :query_object
          click_on 'Go'
        end
  
        within('.results') do
          questions.each { |question| expect(page).to have_content question.title }
          expect(page).to_not have_content 'special question'
          expect(page).to_not have_content 'My test answer'
        end
      end
    end

    scenario 'for the comment' do
      comment = create(:comment, body: 'Awesome')
      other_comment = create(:comment)

      ThinkingSphinx::Test.run do
        within('.search-panel') do
          fill_in "Search:", with: 'Awesome'
          select 'Comment', from: :query_object
          click_on 'Go'
        end
  
        within('.results') do
          expect(page).to have_content "Awesome" 
          expect(page).to_not have_content comment.commentable.body
          expect(page).to_not have_content other_comment.body
          expect(page).to_not have_content other_comment.commentable.body
        end
      end
    end

    scenario 'for the user' do
      user = create(:user, email: 'lara@mail.com')
      other_user = create(:user, email: 'vasya@mail.com')
      question = create(:question, author: user)

      ThinkingSphinx::Test.run do
        within('.search-panel') do
          fill_in "Search:", with: 'lara'
          select 'User', from: :query_object
          click_on 'Go'
        end
  
        within('.results') do
          expect(page).to have_content 'lara'
          expect(page).to_not have_content 'vasya'
          expect(page).to_not have_content question.body
        end
      end
    end

    scenario 'in all models' do
      user = create(:user, email: 'lara@mail.com')
      other_user = create(:user, email: 'vasya@mail.com')
      question = create(:question, author: user)
      answer = create(:answer, author: user)
      comment = create(:comment, author: user)

      ThinkingSphinx::Test.run do
        within('.search-panel') do
          fill_in "Search:", with: 'lara'
          select 'all', from: :query_object
          click_on 'Go'
        end
  
        within('.results') do
          expect(page).to have_content 'lara'
          expect(page).to have_content question.body
          expect(page).to have_content answer.body
          expect(page).to have_content comment.body
          expect(page).to_not have_content 'vasya'
        end
      end
    end
  end
end