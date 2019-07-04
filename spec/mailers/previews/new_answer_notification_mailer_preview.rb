# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notification_mailer
class NewAnswerNotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notification_mailer/notice
  def notice
    NewAnswerNotificationMailer.notice
  end

end
