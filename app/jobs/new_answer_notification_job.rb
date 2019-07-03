class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotification.new.notice(answer)
  end
end
