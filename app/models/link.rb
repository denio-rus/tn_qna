class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::regexp

  def gist_content
    gist = Octokit.gist(parse_gist_id(url))
    gist.files.map.with_object({}) { |(file, val), hash| hash[file] = val[:content] }
  end

  def gist?
    url =~ /^https:\/\/gist.github.com\/*/
  end

  private

  def parse_gist_id(url)
    url.split('/').last
  end
end
