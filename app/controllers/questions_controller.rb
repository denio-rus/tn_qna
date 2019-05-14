class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answers = question.ordered_answers
    @answer = Answer.new
  end

  def new; end

  def edit; end

  def create 
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to question_path(@question), notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update 
    question.update(question_params)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'The question was deleted successfully'
    else 
      redirect_to question, alert: "You can't delete not your question"
    end
  end

  
  def best_answer
    question.update(best_answer_id: params[:answer_id].to_i) if current_user.author_of?(question)
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
