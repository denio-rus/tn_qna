require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value("http://foo.com").for(:url) } 
  it { should_not allow_value("somevalue").for(:url) } 

  #GIST filename: 'gist_for_test.txt', content: "It's a test gist."
  let(:link_gist) { create(:link, :for_answer, url: 'https://gist.github.com/denio-rus/e1bdd70b70726a6d5d7fc57bd490a7a2') }
  let(:link) { create(:link, :for_answer, url: 'http://yandex.ru') }

  it 'returns hash with filenames and content from gist' do
    expect(link_gist.gist_content).to eq(:'gist_for_test.txt' => "It's a test gist.")
  end

  it 'returns true then link is gist on github' do
    expect(link_gist).to be_gist
  end

  it 'returns false then link is not gist' do
    expect(link).to_not be_gist
  end
end
