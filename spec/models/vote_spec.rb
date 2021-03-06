require 'rails_helper'

RSpec.describe Vote, type: :model do
  let!(:vote) { create(:vote) }
  let(:question) { create(:question) }
  
  it { should belong_to :votable }
  it { should belong_to(:user) }

  it { should validate_uniqueness_of(:user_id).scoped_to([:votable_id, :votable_type]) }

  it "validates user isn't votable's author" do
    vote = Vote.new
    vote.votable = question
    vote.user = question.author
 
    expect(vote).to_not be_valid
  end

  it 'votes to like' do
    vote.unvote
    vote.like
    expect(vote.nominal).to eq 'like'
  end

  it 'votes to dislike' do
    vote.unvote
    vote.dislike
    expect(vote.nominal).to eq 'dislike'
  end

  it 'unvotes' do
    vote.unvote
    expect(vote.nominal).to eq 'unvote'
  end
  #factorybot gives vote with nominal 'like'
  it 'returns true if user is already voted - like' do
    expect(vote).to be_voted
  end

  it 'returns true if user is already voted - dislike' do
    vote.unvote
    vote.dislike
    expect(vote).to be_voted
  end

  it 'returns false if user is not already voted' do
    vote.unvote
    expect(vote).to_not be_voted
  end
end
