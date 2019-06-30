class AnswersCollectionSerializer < ActiveModel::Serializer
  attributes :id, :author_name, :body, :best
  
  def author_name
    object.author.email if object.user_id
  end
end