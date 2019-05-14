class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  validate :validate_best_answer

  def best_answer
    answers.find(best_answer_id) if best_answer_id
  end

  def ordered_answers
    best_answer ? answers.reject{ |answer| answer.id == best_answer_id }.unshift(best_answer) : answers
  end

  private
  
  def validate_best_answer
    errors.add(:best_answer_id) if best_answer_id && !answers.ids.include?(best_answer_id)
  end
end
