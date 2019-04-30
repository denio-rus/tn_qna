require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'GET #new' do
    let(:question) { create(:question) }
    it 'assigns the question that answers to @question' do
      get :new, params: { question_id: question } 
      expect(assigns(:question)).to eq question
    end
    it 'assigns a new answer for @question to @answer' do
      get :new, params: { question_id: question }
      expect(assign(:answer)).to be_a_new(:question.answers)
    end

    it 'renders new view' do
      get :new, params: { question_id: question }
      expect(response).to render_templete :new
    end
  end
end
