class Vote < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :votable, polymorphic: true
  
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }
  validate :validate_not_author_of_votable

  enum nominal: { like: 1, unvote: 0, dislike: -1 }

  def like
    update(nominal: 1) unless voted?
  end

  def dislike
    update(nominal: -1) unless voted? 
  end

  def unvote
    update(nominal: 0) if voted?
  end
  
  private

  def voted?
    nominal != 'unvote'
  end

  def validate_not_author_of_votable
    errors.add(:user_id, "Author can't vote!") if votable&.user_id == user_id  && user_id.present?
  end
end
