module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:like, :dislike, :unvote]
    before_action :find_vote, only: [:like, :dislike, :unvote]
  end

  def like
    if @vote
      @vote.like
    else 
      @vote = @votable.votes.create(user: current_user, nominal: 'like')
    end

    respond_to do |format|
      format.json { render json: @votable }
    end
  end

  def dislike
    if @vote
      @vote.dislike
    else 
      @vote = @votable.votes.create(user: current_user, nominal: 'dislike')
    end

    render
  end

  def unvote
    @vote.unvote if @vote

    render
  end

  private

  def find_vote
    @vote = @votable.votes.find_by(user: current_user)
  end

  def render_template(action)
    instance_variable_set("@#{controller_name.singularize}", @votable)
    render "#{controller_name}/#{action}"    
  end
  
  def model_klass
    controller_name.classify.constantize
  end
  
  def set_votable 
    @votable = model_klass.find(params[:id])
  end
end