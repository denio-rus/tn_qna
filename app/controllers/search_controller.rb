class SearchController < ApplicationController
  skip_authorization_check

  def result
    Services::Search.call(params[:query], params[:query_object])
  end
end
