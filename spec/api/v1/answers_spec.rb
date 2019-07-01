require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'applicatipon/json',
                    'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }
  
  describe 'GET /api/v1/questions' do 
    let(:question) {create(:question_with_answers)}
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
    end
                  
    context 'authorized' do 
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns list of answers' do 
        expect(json['answers'].size).to eq question.answers.count
      end

      it 'returns some public fields' do 
        %w[id body best].each do |attr|
          expect(answer_response[attr]).to eq question.answers.first.send(attr).as_json
        end
      end

      it 'contains author name' do
        expect(answer_response['author_email']).to eq question.answers.first.author.email
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do 
    let(:answer) { create(:answer) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
    end

    context "authorized" do
      let(:answer_response) { json['answer'] }
      
      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns all public fields' do 
        %w[id body best question_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
  
      it 'contains user object' do
        expect(answer_response['author']['id']).to eq answer.user_id
      end

      context 'assocciated objects' do 
        let(:resource) { answer }
        let(:resource_response) { answer_response }

        it_behaves_like 'API resource with comments'
  
        it_behaves_like 'API resource with links'
        
        it_behaves_like 'API resource with attached files' do 
          let(:resource) { create(:answer_with_attached_file) }
          let(:api_path) { api_v1_answer_path(resource) }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :post }
    end 

    context 'authorized' do 
      context 'with valid attributes' do
        it 'saves a new answer in the database' do
          expect { post api_path, params: { access_token: access_token.token, 
                                            answer: attributes_for(:answer), 
                                            headers: headers }}.to change(Answer, :count).by(1)
        end
        
        it 'returns 201 status' do 
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer), headers: headers }
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not saves a new answer in the database' do
          expect { post api_path, params: { access_token: access_token.token, 
                                            answer: attributes_for(:answer, :invalid), 
                                            headers: headers }}.to_not change(Answer, :count)
        end

        it 'returns errors object' do 
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid), headers: headers }
          expect(json['body']).to eq ["can't be blank"]
        end
        
        it 'returns 422 status' do 
          post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer, :invalid), headers: headers }
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :patch }
    end 

    context 'authorized' do
      context "An author" do
        let(:author_user) { User.find(access_token.resource_owner_id) }
        let(:answer) { create(:answer, author: author_user) }

        context 'with valid attributes' do
          before { patch api_path, params: { access_token: access_token.token, 
                                             answer: { body: 'new body' }, 
                                             headers: headers } }
          
          it 'changes answer attributes' do
            answer.reload

            expect(answer.body).to eq 'new body'
          end

          it 'returns 202 status' do 
            expect(response.status).to eq 202
          end          
        end
        
        context 'with invalid attributes' do
          it 'does not changes answer attributes' do
            body = answer.body

            patch api_path, params: { access_token: access_token.token, 
                                      answer: { body: '' }, 
                                      headers: headers }
            answer.reload
            
            expect(body).to eq answer.body
          end

          it 'returns errors object' do 
            patch api_path, params: { access_token: access_token.token, 
                                      answer: { body: '' }, 
                                      headers: headers }
            expect(json['body']).to eq ["can't be blank"]
          end

          it 'returns 422 status' do 
            patch api_path, params: { access_token: access_token.token, 
                                      answer: { body: '' }, 
                                      headers: headers }

            expect(response.status).to eq 422
          end  
        end
      end

      context "Not an author tries to change answer" do
        it 'does not change the answer' do
          body = answer.body

          patch api_path, params: { access_token: access_token.token, 
                                    answer: { body: 'new body' }, 
                                    headers: headers } 
          answer.reload
          
          expect(body).to eq answer.body
        end

        it 'returns response with forbidden status' do
          patch api_path, params: { access_token: access_token.token, 
                                    answer: { body: 'new body' }, 
                                    headers: headers } 

          expect(response).to have_http_status :forbidden
        end        
      end
    end
  end
end