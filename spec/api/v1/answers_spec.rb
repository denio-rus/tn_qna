require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'applicatipon/json',
                    'ACCEPT' => 'application/json' } }
  
  describe 'GET /api/v1/questions' do 
    let(:question) {create(:question_with_answers)}
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do 
      let(:method) { :get }
    end
                  
    context 'authorized' do 
      let(:access_token) { create(:access_token) }
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
      let(:access_token) { create(:access_token) }
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
end