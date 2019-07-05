require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question } 
    it { should be_able_to :read, Answer } 
    it { should be_able_to :read, Comment }
    it { should be_able_to :search, :all }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
  
    it { should be_able_to :manage, :all }
    it { should be_able_to :search, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question_of_user) { create :question, user_id: user.id }
    let(:question_of_other_user) { create :question, user_id: other_user.id }
    let(:answer_of_user) { create :answer, user_id: user.id }
    let(:answer_of_other_user) { create :answer, user_id: other_user.id }
    let(:subscription_of_user) { create :subscription, user_id: user.id }
    let(:subscription_of_other_user) { create :subscription, user_id: other_user.id }
  
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :search, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Subscription }
    it { should be_able_to :create_comment, Comment }
    
    it { should be_able_to :update, question_of_user }
    it { should_not be_able_to :update, question_of_other_user }

    it { should be_able_to :update, answer_of_user }
    it { should_not be_able_to :update, answer_of_other_user }

    it { should be_able_to :destroy, question_of_user }
    it { should_not be_able_to :destroy, question_of_other_user }

    it { should be_able_to :destroy, answer_of_user }
    it { should_not be_able_to :destroy, answer_of_other_user }

    it { should be_able_to :destroy, subscription_of_user }
    it { should_not be_able_to :destroy, subscription_of_other_user }    
    
    context 'Links' do
      it { should be_able_to :destroy, create(:link, linkable: question_of_user) }
      it { should_not be_able_to :destroy, create(:link, linkable: question_of_other_user) }
      it { should be_able_to :destroy, create(:link, linkable: answer_of_user) }
      it { should_not be_able_to :destroy, create(:link, linkable: create(:answer, user_id: other_user.id )) }
    end
    
    context "Attachments" do
      it { should be_able_to :destroy, create(:question_with_attached_file, user_id: user.id).files.first }
      it { should_not be_able_to :destroy, create(:question_with_attached_file, user_id: other_user.id).files.first }
      it { should be_able_to :destroy, create(:answer_with_attached_file, user_id: user.id).files.first }
      it { should_not be_able_to :destroy, create(:answer_with_attached_file, user_id: other_user.id).files.first }
    end

    context "Best answer" do
      it { should be_able_to :best, create(:answer, question: question_of_user) }
      it { should_not be_able_to :best, create(:answer, question: question_of_other_user) }
    end
    
    context 'Voting' do
      it { should_not be_able_to [:like, :dislike, :unvote], create(:vote, votable: question_of_user) }
      it { should be_able_to [:like, :dislike, :unvote], create(:vote, user_id: user.id, 
                                                                votable: question_of_other_user) }
      it { should_not be_able_to [:like, :dislike, :unvote], create(:vote, votable: answer_of_user) }
      it { should be_able_to [:like, :dislike, :unvote], create(:vote, user_id: user.id, 
                                                                votable: answer_of_other_user) }
        
      it { should_not be_able_to :create_vote, create(:vote, votable: question_of_user) }
      it { should be_able_to :create_vote, create(:vote, votable: question_of_other_user) } 
    end
  end
end
 