require 'rails_helper'

shared_examples_for 'voted' do
  resource_factory_name = described_class.controller_name.classify.underscore.to_sym
  let(:user) { create(:user) }
  let(:vote) { create(:vote, nominal: 0) }
  let(:resource) { create(resource_factory_name) }

  before { login(user) }   
  
  describe "PATCH#like" do
    it 'assigns voting resource to @votable' do
      patch :like, params: { id: resource.id }, format: :json
      expect(assigns(:votable)).to eq resource
    end

    context 'an existing vote' do
      let!(:vote_of_user) { create(:vote, votable: resource, user: user, nominal: 0) }

      before { patch :like, params: { id: resource.id }, format: :json }

      it 'finds vote of current user and assigns it to @vote' do
        expect(assigns(:vote)).to eq vote_of_user
      end

      it "changes nominal of vote to 'like'" do
        expect(assigns(:vote).nominal).to eq 'like'
      end

      it 'responds with json and status :success' do
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end
    
    context "a new vote" do
      it 'creates a new instance of vote for voting resource' do
        expect { patch :like, params: { id: resource.id }, format: :json }.to change(resource.votes, :count).by(1)
      end

      it "sets nominal of creating vote to 'like'" do
        patch :like, params: { id: resource.id }, format: :json
        expect(resource.votes.last.nominal).to eq 'like'
      end

      it 'responds with json and status :success' do
        patch :like, params: { id: resource.id }, format: :json
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "PATCH#dislike" do
    context 'an existing vote' do
      let!(:vote_of_user) { create(:vote, votable: resource, user: user, nominal: 0) }

      before { patch :dislike, params: { id: resource.id }, format: :json }
      it 'finds vote of current user and assigns it to @vote' do
        expect(assigns(:vote)).to eq vote_of_user
      end

      it "changes nominal of vote to 'dislike'" do
        expect(assigns(:vote).nominal).to eq 'dislike'
      end

      it 'responds with json and status :success' do
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end
    
    context "new vote" do
      it 'creates a new instance of vote for voting resource' do
        expect { patch :dislike, params: { id: resource.id }, format: :json }.to change(resource.votes, :count).by(1)
      end

      it "sets nominal of creating vote to 'dislike'" do
        patch :dislike, params: { id: resource.id }, format: :json
        expect(resource.votes.last.nominal).to eq 'dislike'
      end

      it 'responds with json and status :success' do
        patch :dislike, params: { id: resource.id }, format: :json
        expect(response.content_type).to eq 'application/json'
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'PATCH#unvote' do
    let!(:vote_of_user) { create(:vote, votable: resource, user: user, nominal: 'dislike') }

    it 'sets nominal of existing vote of current user' do
      patch :unvote, params: { id: resource.id }, format: :json
      expect(assigns(:vote).nominal).to eq 'unvote'
    end

    it 'responds with json and status :success' do
      patch :dislike, params: { id: resource.id }, format: :json
      expect(response.content_type).to eq 'application/json'
      expect(response).to have_http_status(:success)
    end
  end
end
