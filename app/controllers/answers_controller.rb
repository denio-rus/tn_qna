class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    
    if @answer.save
      flash.now[:notice] = 'Your answer was saved successfully!'
    else
      flash.now[:alert] = "Answer wasn't saved"
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'The answer was deleted successfully'
    else 
      flash[:alert] = "You can't delete not your answer"
    end
    redirect_to question_path(@answer.question)
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
