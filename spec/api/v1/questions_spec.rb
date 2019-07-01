require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'applicatipon/json',
                    'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do 
    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do 
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns list of questions' do 
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do 
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do 
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do 
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do 
          %w[id body best question_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do 
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
    end

    context "authorized" do
      let(:question_response) { json['question'] }
      
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns all public fields' do 
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end
  
      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.user_id
      end

      context 'assocciated objects' do 
        let(:resource) { question }
        let(:resource_response) { question_response }

        it_behaves_like 'API resource with comments'
  
        it_behaves_like 'API resource with links'
        
        it_behaves_like 'API resource with attached files' do 
          let(:resource) { create(:question_with_attached_file) }
          let(:api_path) { api_v1_question_path(resource) }
        end
      end
    end
  end

  describe 'post /api/v1/questions/' do 
    let(:api_path) { api_v1_questions_path }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :post }
    end 

    context 'authorized' do 
      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post api_path, params: { access_token: access_token.token, 
                                            question: attributes_for(:question), 
                                            headers: headers }}.to change(Question, :count).by(1)
        end
        
        it 'returns 201 status' do 
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question), headers: headers }
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not saves a new question in the database' do
          expect { post api_path, params: { access_token: access_token.token, 
                                            question: attributes_for(:question, :invalid), 
                                            headers: headers }}.to_not change(Question, :count)
        end

        it 'returns errors object' do 
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid), headers: headers }
          expect(json['title']).to eq ["can't be blank"]
        end
        
        it 'returns 422 status' do 
          post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid), headers: headers }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :patch }
    end 

    context 'authorized' do
      context "An author" do
        let(:author_user) { User.find(access_token.resource_owner_id) }
        let(:question) { create(:question, author: author_user) }

        context 'with valid attributes' do
          before { patch api_path, params: { access_token: access_token.token, 
                                             question: { title: 'new title', body: 'new body' }, 
                                             headers: headers } }
          
          it 'changes question attributes' do
            question.reload
  
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'returns 202 status' do 
            expect(response.status).to eq 202
          end          
        end
        
        context 'with invalid attributes' do
          it 'does not changes question attributes' do
            title = question.title
            body = question.body

            patch api_path, params: { access_token: access_token.token, 
                                      question: { title: 'new title', body: '' }, 
                                      headers: headers }
            question.reload
            
            expect(title).to eq question.title
            expect(body).to eq question.body
          end

          it 'returns errors object' do 
            patch api_path, params: { access_token: access_token.token, 
                                      question: { title: 'new title', body: '' }, 
                                      headers: headers }
            expect(json['body']).to eq ["can't be blank"]
          end

          it 'returns 422 status' do 
            patch api_path, params: { access_token: access_token.token, 
                                      question: { title: 'new title', body: '' }, 
                                      headers: headers }

            expect(response.status).to eq 422
          end  
        end
      end

      context "Not an author tries to change question" do
        it 'does not change the question' do
          title = question.title
          body = question.body

          patch api_path, params: { access_token: access_token.token, 
                                    question: { title: 'new title', body: 'new body' }, 
                                    headers: headers } 
          question.reload
          
          expect(title).to eq question.title
          expect(body).to eq question.body
        end

        it 'returns response with forbidden status' do
          patch api_path, params: { access_token: access_token.token, 
                                    question: { title: 'new title', body: 'new body' }, 
                                    headers: headers } 

          expect(response).to have_http_status :forbidden
        end        
      end
    end
  end
end
