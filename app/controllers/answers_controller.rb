class AnswersController < ApplicationController
  before_action :find_question, only: [:new, :create]
  
  def new 
    @answer = @question.answers.new
  end

  def create
    @question.answers.create(answer_params)
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
