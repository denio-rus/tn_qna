class Question < ApplicationRecord
  include Votable
  include Linkable
  include Attachable
  include Commentable
  
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscribes, dependent: :destroy
  has_many :subscribers, through: :subscribes, source: 'user'

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  scope :created_for_day, -> { where(created_at: (1.day.ago .. Time.now)) }

  after_create :calculate_reputation, :subscribe_author

  def best_answer
    answers.find_by(best: true)
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    subscribes.create(user_id: user_id)
  end
end
