require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #result" do
    context 'valid request' do
      let(:questions) { create_list(:question, 2) }
      
      before do 
        allow(Services::Search).to receive(:call).and_return(questions)
      end

      it 'assigns result of calling Services::Search to @result' do
        get :result, params: {query: 'Text', query_object: 'all', page: '1', per_page: '20' }
        expect(assigns(:result)).to eq questions
      end

      it "returns http success" do
        get :result, params: {query: 'Text', query_object: 'all', page: '1', per_page: '20' }
        expect(response).to have_http_status(:success)
      end

      it "renders :result template" do
        get :result, params: {query: 'Text', query_object: 'all', page: '1', per_page: '20' }
        expect(response).to render_template :result
      end
    end
  
    context 'invalid request' do
      it 'redirects to root_path' do
        get :result, params: {query: 'test', query_object: '', page: '1', per_page: '20' }
        expect(response).to redirect_to root_path
      end

      it "set flash alert" do
        get :result, params: {query: '', query_object: 'all', page: '1', per_page: '20' }
        expect(controller).to set_flash[:alert].to 'Empty query'
      end
    end
  end
end
