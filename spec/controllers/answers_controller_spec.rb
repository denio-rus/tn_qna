require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }
  
  describe 'GET #new' do
    before { get :new, params: { question_id: question } }
    
    it 'assigns the question that answers to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer for authenticated user to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:answer).author).to eq user
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'assigns the question that answers to @question' do
      post :create, params: { answer: attributes_for(:answer), question_id: question }
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer to the question to @answer' do
      post :create, params: { answer: attributes_for(:answer), question_id: question }
      expect(assigns(:answer)).to eq question.answers.last
    end

    it 'sets attribute author of the answer to authenticated user' do
      post :create, params: { answer: attributes_for(:answer), question_id: question, author: user }
      expect(assigns(:answer).author).to eq user
    end

    context 'with valid attributes' do
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
    let(:answer) { create(:answer, body: 'test_delete_answer') }
    
    it 'finds the answer by id and it assigns to @answer' do
      delete :destroy, params: { id: answer }
      expect(assigns(:answer)).to eq answer
    end

    it 'An author deletes his answer' do
      sign_in(answer.author)
      
      expect { delete :destroy, params: { id: answer } }.to change(answer.author.answers, :size).by(-1)
    end
 
    it 'Some user tries to delete not his answer' do
      sign_in(user)
      
      expect { delete :destroy, params: { id: answer } }.to_not change(answer.author.answers, :size)
    end

    it 'redirects to the question page' do
      delete :destroy, params: { id: answer }

      expect(response).to redirect_to answer.question
    end
  end
end
