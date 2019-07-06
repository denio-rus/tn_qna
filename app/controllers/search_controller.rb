class SearchController < ApplicationController
  def result
    authorize! :search, :all
    if params[:query].present? && params[:query_object].present?
      @result = Services::Search.call(params[:query], params[:query_object], params[:page], params[:per_page])
      parse_result(@result)
    else
     redirect_to root_path, alert: 'Empty query'
    end
  end

  private

  def parse_result(result)
    @questions, @answers, @comments, @users = [], [], [], []

    result.each do |item|
      case item.class.name
      when "Question"
        @questions << item
      when "Answer"
        @answers << item
      when "Comment"
        @comments << item
      else
        @users << item
      end
    end
  end
end
