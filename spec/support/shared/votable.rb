require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  
  it '#rating' do
    vote = create(:vote, "for_#{model.to_s.underscore}".to_sym)  
    expect(vote.votable.rating).to eq 1
  end
end