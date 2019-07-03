require 'rails_helper'

RSpec.describe SubscribesController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }

  before { login(user) }

  describe 'POST #create' do
    before { post :create, params: { question_id: question } }

    it 'assigns the question that subscribes to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'creates subscribe to @question with current_user' do
      expect(assigns(:question).subscribes.first.user).to eq user
    end

    it 'redirects to the question page' do 
      expect(response).to redirect_to assigns(:question)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes subscribe of current user to the question' do
      expect { delete :destroy, params: { id: question.subscribes.first } }.to change(Subscribe, :count).by(-1)
    end

    it 'redirects to the question page' do 
      delete :destroy, params: { id: question.subscribes.first }
      expect(response).to redirect_to question
    end
  end  
end
