module ApplicationHelper
  def delete_attachment_path(resource, file)
    "/#{resource.class.name.downcase}s/#{resource.id}/attachment/#{file.id}"
  end
end
