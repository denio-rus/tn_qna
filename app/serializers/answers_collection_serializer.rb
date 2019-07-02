class AnswersCollectionSerializer < ActiveModel::Serializer
  attributes :id, :author_email, :body, :best
  
  def author_email
    object.author.email if object.user_id
  end
end