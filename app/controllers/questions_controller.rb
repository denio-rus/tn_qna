class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @answers = question.answers.best_first
    @answer = Answer.new
    @answer.links.new
  end

  def new
    question.links.new
  end

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
    question.update(question_params) if current_user.author_of?(question)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'The question was deleted successfully'
    else 
      redirect_to question, alert: "You can't delete not your question"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:name, :url]) 
  end
end
