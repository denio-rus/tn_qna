class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :created_at 
  attribute :link do
    {
      "#{name}": url
    } 
  end

  def name
    object.filename.to_s
  end

  def url
    url_for(object)
  end
end