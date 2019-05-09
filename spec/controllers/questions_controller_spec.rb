require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) {create(:question)}
  let(:user) { create(:user) }

  describe 'GET #index' do 
    let(:questions) { create_list(:question, 3) }
    
    before { get :index }

    it 'populates an array of all questions' do 
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do 
    let(:question) {create(:question_with_answers, answers_count: 7)}

    before { get :show, params: { id: question } }

    it 'populates an array of all answers to the question' do 
      expect(assigns(:answers)).to match_array(question.answers)
    end

    it 'assigns a new instance of Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do 
      it 'assigns a new question of current user to @question' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:question).author).to eq user
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do 
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do 
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the upgraded question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change the question' do
        title = question.title
        body = question.body

        patch :update, params: { id: question, question: attributes_for(:question, :invalid) } 
        question.reload
        
        expect(title).to eq question.title
        expect(body).to eq question.body
      end

      it 're-renders edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end
  
  describe 'DELETE #destroy' do
    before { login(user) } 
    
    context 'Author' do
      let!(:question) { create(:question, author: user) }
      
      it 'deletes his question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end
  
      it 'redirect to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context "User tries to delete not his question" do
      let!(:question) { create(:question) }

      it "doesn't delete the question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to show question page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end
end
