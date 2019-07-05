class SearchController < ApplicationController
  skip_authorization_check

  def result
    if params[:query].present?
      parse_result(Services::Search.call(params[:query], params[:query_object]))
    else
      redirect_to root_path, alert: 'Empty query'
    end
  end

  private

  def parse_result(result)
    @questions, @answers, @comments, @people = [], [], [], []

    result.each do |item|
      case item.class.name
      when "Question"
        @questions << item
      when "Answer"
        @answers << item
      when "Comment"
        @comments << item
      else
        @people << item
      end
    end
  end
end
