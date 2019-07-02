shared_examples_for 'API resource with attached files' do 
  before { get api_path, params: { access_token: access_token.token },headers: headers }

  it 'returns all files attached to the resource' do 
    expect(resource_response['files'].size).to eq resource.files.count
  end    

  it 'contains objects with links to attached files' do
    file_object = resource_response['files'].first
    attached_file = resource.files.where(id: file_object['id']).first
    expect(file_object['link'][attached_file.filename.to_s]).to eq url_for(attached_file)
  end
end