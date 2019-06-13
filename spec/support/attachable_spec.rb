require 'rails_helper'

shared_examples_for 'attachable' do
  let(:model) { described_class }
  
  it '#file_links_in_hash' do
    attachable = create("#{model.to_s.underscore}_with_attached_file".to_sym)  
    expect(attachable.file_links_in_hash.first).to eq({ id: attachable.files.first.id,
                                                        name: 'rails_helper.rb',
                                                        url: Rails.application.routes.url_helpers.rails_blob_url(attachable.files.first, only_path: true) })
  end
end