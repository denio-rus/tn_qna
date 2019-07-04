class SubscriptionsController < ApplicationController
  load_and_authorize_resource 

  def create  
    @question = Question.find(params[:question_id])
    @question.subscriptions.create(user: current_user)
    redirect_to @question
  end

  def destroy
    @subscription.destroy
    redirect_to @subscription.question
  end
end
