module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:create_comment]
    after_action :publish_comment, only: [:create_comment]
  end

  def create_comment
    authorize! :create_comment, Comment
    gon.question_id = question_id
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    respond_to do |format|
      if @comment.save
        format.json { render json: comment_object_for_jst }
      else
        format.json do 
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("comments_on_page_of_question_#{question_id}", comment_object_for_jst)
  end

  def question_id
    if @commentable.is_a?(Question)
      @commentable.id
    else
      @commentable.question_id
    end
  end

  def comment_object_for_jst
    { 
      comment: @comment, 
      user: current_user.email 
    }
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end
  
  def set_commentable 
    @commentable = model_klass.find(params[:id])
  end
end