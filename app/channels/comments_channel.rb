class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_on_page_of_question_#{data['question_id']}"
  end
end