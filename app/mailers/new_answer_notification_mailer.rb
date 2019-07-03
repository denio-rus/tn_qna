class NewAnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.notice.subject
  #
  def notice(answer)
    @greeting = "Hi"
    @answer = answer
    mail to: answer.question.author.email
  end
end
