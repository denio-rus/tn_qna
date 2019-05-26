class Reward < ApplicationRecord
  belongs_to :rewardable, polymorphic: true

  has_one_attached :image

  validates :title, presence: true
end
