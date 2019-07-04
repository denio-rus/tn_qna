class Answer < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  include Commentable
  
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true
  
  scope :best_first, -> { order(best: :desc) }
  
  after_create :notice_question_subscribers

  def set_best
    transaction do
      question.answers.update_all(best: false)
      question.reward.update!(user: author) if question.reward
      update!(best: true)
    end
  end

  def notice_question_subscribers
    NewAnswerNotificationJob.perform_later(self)
  end
end
