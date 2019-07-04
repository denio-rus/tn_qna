class Services::NewAnswerNotification
  def notice(answer)
    answer.question.subscribers.each do |subscriber|
      NewAnswerNotificationMailer.notice(subscriber, answer).try(:deliver_later)
    end
  end
end