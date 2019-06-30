class Api::V1::AnswersController < Api::V1::BaseController
  def index 
    @question = Question.find(params[:question_id])    
    @answers = @question.answers
    render json: @answers, each_serializer: AnswersCollectionSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end