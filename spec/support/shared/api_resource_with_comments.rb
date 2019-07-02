shared_examples_for 'API resource with comments' do 
  let!(:comments) { create_list(:comment, 3, commentable: resource) }

  before { get api_path, params: { access_token: access_token.token },headers: headers }

  it 'returns all comments to the resource' do
    expect(resource_response['comments'].size).to eq 3
  end    

  it 'contains comments objects' do
    resource_response['comments'].each do |comment|
      expect(resource.comments.ids).to include comment['id'].to_i
    end
  end
end