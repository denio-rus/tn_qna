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

      it 'renders create template' do 
        post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js 
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js 
        expect(response).to render_template :create
      end
    end
  end
  
  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer) }
    
    it 'finds the answer by id and it assigns to @answer' do
      delete :destroy, params: { id: answer }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    context 'An author' do
      let!(:answer) { create(:answer, author: user) }

      it 'deletes his answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders template destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
    
    context 'Some user' do
      it 'tries to delete not his answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
      
      it 'renders template destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATH #update' do
    let!(:answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end .to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end
end
