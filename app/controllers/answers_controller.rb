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
      @answers = @question.answers.reload
      flash.now[:alert] = "Answer wasn't saved"
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user == @answer.author
      @answer.destroy
      flash[:notice] = 'The answer was deleted successfully'
    else 
      flash[:alert] = "You can't delete not your answer"
    end
    redirect_to @answer.question
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
