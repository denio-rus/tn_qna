require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'applicatipon/json',
                    'ACCEPT' => 'application/json' } }
  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }
    it_behaves_like 'API Authorizable'

    context 'authorized' do 
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get api_path, params: { access_token: access_token.token },headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it 'returns all public fields' do 
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do 
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/others' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/others' }
    end

    context 'authorized' do 
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:other_users) { create_list(:user, 4) }

      before { get '/api/v1/profiles/others', params: { access_token: access_token.token },headers: headers }

      it 'returns 200 status' do 
        expect(response).to be_successful
      end

      it "returns all other user's profiles" do 
        expect(json['users'].size).to eq 4
      end

      it 'does not return user profile' do 
        json['users'].each do |user|
          expect(user['id']).to_not eq me.id
        end
      end
    end
  end
end
