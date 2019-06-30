class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show, :destroy, :update]
  
  authorize_resource 

  def index 
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsCollectionSerializer
  end

  def show
    render json: @question
  end

  def create 
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      head :created
    else
      render json: @question.errors, status: 422
    end
  end

  def destroy 
    @question.destroy
  end

  def update 
    @question.update(question_params)
    if @question.errors.any?
      render json: @question.errors, status: 422
    else
      head :accepted
    end
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                     links_attributes: [:id, :name, :url],
                                     reward_attributes: [:id, :title, :image]) 
  end
end
