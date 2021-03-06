module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :unvote]
    before_action :find_vote, only: [:like, :dislike, :unvote]
  end

  # in controller included Voted need to add: skip_authorize_resource only: [:like, :dislike, :unvote]

  def like
    if @vote
      authorize! :like, @vote
      @vote.like
    else 
      authorize! :create_vote, @votable.votes.new
      @votable.votes.create(user: current_user, nominal: 'like')
    end

    rating_respond_with_json
  end

  def dislike
    if @vote
      authorize! :dislike, @vote
      @vote.dislike
    else 
      authorize! :create_vote, @votable.votes.new
      @votable.votes.create(user: current_user, nominal: 'dislike')
    end

    rating_respond_with_json
  end

  def unvote
    authorize! :unvote, @vote
    @vote.unvote if @vote

    rating_respond_with_json
  end

  private

  def rating_respond_with_json
    render json: { rating: @votable.rating } 
  end

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end
  
  def model_klass
    controller_name.classify.constantize
  end
  
  def set_votable 
    @votable = model_klass.find(params[:id])
  end
end