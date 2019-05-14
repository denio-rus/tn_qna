class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy]

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
    if current_user.author_of?(@answer)
      @answer.question.update(best_answer_id: nil) if @answer.question.best_answer_id == @answer.id
      @answer.destroy     
    end
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
