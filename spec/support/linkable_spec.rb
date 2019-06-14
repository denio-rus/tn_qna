require 'rails_helper'

shared_examples_for 'linkable' do
  let(:model) { described_class }
  
  it '#links_in_hash' do
    link = create(:link, "for_#{model.to_s.underscore}".to_sym)  
    expect(link.linkable.links_in_hash.first).to eq({ id: link.id, name: link.name, url: link.url })
  end
end