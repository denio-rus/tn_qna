class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :question_id, :created_at, :updated_at
  
  belongs_to :author
  has_many :comments
  has_many :files, serializer: AttachmentSerializer
  has_many :links
end