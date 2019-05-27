class Answer < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
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
