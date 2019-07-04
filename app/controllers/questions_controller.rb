class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create]

  authorize_resource 
  skip_authorize_resource only: [:like, :dislike, :unvote, :create_comment]

  def index
    @questions = Question.all
  end

  def show
    question.links.build if question.links.empty?
    @answers = question.answers.best_first
    @answer = Answer.new
    @answer.links.new
    @comment = Comment.new
    @subscription = question.subscriptions.find_by(user_id: current_user.id) if current_user
    gon.question_id = question.id
  end

  def new
    question.links.new
    question.build_reward
  end

  def create 
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to question_path(@question), notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update 
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
    redirect_to questions_path, notice: 'The question was deleted successfully'
  end
  
  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_inline',
        locals: { question: @question }
      )
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:id, :title, :image]) 
  end
end
