module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commentable, only: [:create_comment]
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.author = current_user

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment }
      else
        format.json do 
          render json: @comment.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  private

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