class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end
