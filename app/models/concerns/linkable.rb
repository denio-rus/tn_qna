module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, as: :linkable, dependent: :destroy
    accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  end

  def links_in_hash
    return unless links.any?
    gists, simple_links = links.partition { |link| link.gist? }

    gist_arr = gists.map.with_object([]) { |link, arr| arr << { name: link.name, content: link.gist_content} }
    simple_links_arr = simple_links.map.with_object([]) { |link, arr| arr << { name: link.name, url: link.url} }

    gist_arr + simple_links_arr
  end
end
