require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  describe 'POST #create' do
    it 'assigns the question that answers to @question' do
      post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js 
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'sets attribute author of the answer to authenticated user' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, author: user }, format: :js 
        expect(assigns(:answer).author).to eq user
      end

      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, author: user }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show question view' do 
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js 
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders question show view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js 
        expect(response).to render_template :create
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

      it 'deletes his answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to the question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
    
    context 'Some user' do
      it 'tries to delete not his answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
      
      it 'redirects to the question page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end
  end
end
