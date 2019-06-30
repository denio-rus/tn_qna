class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  
  has_many :answers
  belongs_to :author
  has_many :comments
  has_many :files, serializer: AttachmentSerializer
  has_many :links
end