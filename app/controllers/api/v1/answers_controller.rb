class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:create, :index]
  before_action :find_answer, only: [:update, :destroy, :show]

  authorize_resource 

  def index 
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersCollectionSerializer
  end

  def show
    render json: @answer
  end

  def create 
    @answer = @question.answers.new(answer_params)
    @answer.author = current_resource_owner
    if @answer.save
      head :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def destroy 
    @answer.destroy
  end

  def update 
    @answer.update(answer_params)
    if @answer.errors.any?
      render json: @answer.errors, status: :unprocessable_entity
    else
      head :accepted
    end
  end

  private

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: [:id, :name, :url])
  end
end