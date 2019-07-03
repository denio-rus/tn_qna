class SubscribesController < ApplicationController
  load_and_authorize_resource 

  def create  
    @question = Question.find(params[:question_id])
    Subscribe.create(user: current_user, question: @question)
    redirect_to @question
  end

  def destroy
    @subscribe.destroy
    redirect_to @subscribe.question
  end
end
