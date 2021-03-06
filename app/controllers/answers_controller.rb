class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :best]
  after_action :publish_answer, only: [:create]

  authorize_resource
  skip_authorize_resource only: [:like, :dislike, :unvote, :create_comment]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    
    respond_to do |format|
      if @answer.save
        format.json { render json: answer_object_for_jst }
      else
        format.json do 
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @answer.destroy
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @answer.set_best
  end
 
  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_for_question_#{@question.id}", answer_object_for_jst)
  end

  def answer_object_for_jst
    { 
      answer: @answer,
      links: @answer.links_in_hash,
      rating: @answer.rating,
      files: @answer.file_links_in_hash,
      question_user_id: @answer.question.user_id
    }
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
