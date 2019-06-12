module Attachable
  extend ActiveSupport::Concern

  included do
    has_many_attached :files
  end

  def file_links_in_hash
    files.map.with_object([]) do |file, arr| 
      arr << { name: file.filename.to_s, 
               url: Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
    end
  end
end
