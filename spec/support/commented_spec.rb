require 'rails_helper'

shared_examples_for 'commented' do
  resource_factory_name = described_class.controller_name.classify.underscore.to_sym
  let(:user) { create(:user) }
  let(:resource) { create(resource_factory_name) }

  before { login(user) }  
  
  describe "POST #create_comment" do
    it 'assigns the commentable resource to @commentable' do
      post :create_comment, params: { id: resource, comment: attributes_for(:comment) }, format: :json 
      expect(assigns(:commentable)).to eq resource
    end

    context 'with valid attributes' do
      it 'sets attribute author of the comment to authenticated user' do
        post :create_comment, params: { id: resource, comment: attributes_for(:comment) }, format: :json 
        expect(assigns(:comment).author).to eq user
      end

      it 'saves a new comment in the database' do
        expect { post :create_comment, params: { id: resource, comment: attributes_for(:comment) }, format: :json  }.to change(resource.comments, :count).by(1)
      end

      it 'responds with json and status :success' do 
        post :create_comment, params: { id: resource, comment: attributes_for(:comment) }, format: :json 
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new answer in the database' do
        expect { post :create_comment, params: { id: resource, comment: attributes_for(:comment, :invalid) }, format: :json }.to_not change(Comment, :count)
      end

      it 'esponds with json and status :unprocessable_entity' do
        post :create_comment, params: { id: resource, comment: attributes_for(:comment, :invalid) }, format: :json 
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(422)
      end
    end
  end
end