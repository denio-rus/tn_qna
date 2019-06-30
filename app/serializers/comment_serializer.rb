class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author_name, :user_id, :body, :created_at, :updated_at

  def author_name
    object.author.email if object.user_id
  end
end