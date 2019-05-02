require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }
    before { get :new, params: { question_id: question } }
    
    it 'assigns the question that answers to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer for @question to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it 'assigns the question that answers to @question' do
      post :create, params: { answer: attributes_for(:answer), question_id: question }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end
    end
  end
end
