shared_examples_for 'API resource with links' do 
  let!(:links) { create_list(:link, 3, linkable: resource) }

  before { get api_path, params: { access_token: access_token.token },headers: headers }

  it 'returns all links of the resource' do 
    expect(resource_response['links'].size).to eq resource.links.count
  end    

  it 'contains objects with links' do
    link_object = resource_response['links'].first
    link = resource.links.where(id: link_object['id']).first

    expect(link_object['name']).to eq link.name
    expect(link_object['url']).to eq link.url
  end
end