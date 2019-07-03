class Services::NewAnswerNotification
  def notice(answer)
    NewAnswerNotificationMailer.notice(answer).deliver_later
  end
end