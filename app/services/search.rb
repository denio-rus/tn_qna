class Services::Search
  QUERY_OBJECTS = { all: :all, Question: :Question, Answer: :Answer, Comment: :Comment, User: :User }.freeze

  def initialize(query, query_object)
    @query = query
    @query_object = query_object
  end

  def self.query_objects
    QUERY_OBJECTS
  end

  def self.call(query, query_object)
    new(query, query_object).call
  end

  def call
    return ThinkingSphinx.search(@query) if @query_object == 'all'

    Object.const_get(@query_object).search(@query)
  end
end