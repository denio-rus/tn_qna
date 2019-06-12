class Answer < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question

  validates :body, presence: true
  
  scope :best_first, -> { order(best: :desc) }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      question.reward.update!(user: author) if question.reward
      update!(best: true)
    end
  end
end
