class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :questions, inverse_of: :author, dependent: :nullify
  has_many :answers, inverse_of: :author, dependent: :nullify 
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :nullify

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    
  end
end
