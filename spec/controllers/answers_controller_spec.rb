require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    it 'assigns the question that answers to @question' do
      post :create, params: { answer: attributes_for(:answer), question_id: question }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'assigns a new answer to the question to @answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer)).to eq question.answers.last
      end
  
      it 'sets attribute author of the answer to authenticated user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, author: user }
        expect(assigns(:answer).author).to eq user
      end

      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, author: user } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do 
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    
    it 'finds the answer by id and it assigns to @answer' do
      delete :destroy, params: { id: answer }
      expect(assigns(:answer)).to eq answer
    end

    context 'An author' do
      let!(:answer) { create(:answer, author: user) }

      it 'verifies the current user is not an author of the answer' do
        delete :destroy, params: { id: answer }
        expect(user).to eq answer.author
      end

      it 'deletes his answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end
    end
    
    context 'Some user' do
      it 'verifies the current user is not an author of the answer' do
        delete :destroy, params: { id: answer }
        expect(user).to_not eq answer.author
      end

      it 'tries to delete not his answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end

    it 'redirects to the question page' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to answer.question
    end
  end
end
