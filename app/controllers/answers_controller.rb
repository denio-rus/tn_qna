class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  
  def new 
    @answer = current_user.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    
    if @answer.save
      redirect_to @question, notice: 'Your answer was saved successfully!'
    else
      @answers = @question.answers
      flash.now[:alert] = "Answer wasn't saved"
      render 'questions/show'
    end
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
