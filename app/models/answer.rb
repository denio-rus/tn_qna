class Answer < ApplicationRecord
  include Votable
  
  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :question
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  
  validates :body, presence: true
  
  scope :best_first, -> { order(best: :desc) }

  def set_best
    transaction do
      question.answers.update_all(best: false)
      question.reward.update!(user: author) if question.reward
      update!(best: true)
    end
  end

  def links_to_hash
    return unless links.any?

    gists = []
    simple_links = []
    hash = {}

    links.map do |link|
      if link.gist?
        gists << { name: link.name, content: link.gist_content }
      else
        simple_links << { name: link.name, url: link.url }
      end
    end

    hash[:gists] = gists if gists
    hash[:simple_links] = simple_links if simple_links
    
    hash
  end

  def files_links_to_hash
    files.map.with_object({}) { |file, hash| hash[file.filename.to_s] = url_for(file) }
  end
end
