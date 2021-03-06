class Services::Search
  QUERY_OBJECTS = { all: :all, Question: :Question, Answer: :Answer, Comment: :Comment, User: :User }.freeze

  def initialize(query, query_object, page = '1', per_page = '20')
    @query = query
    @query_object = query_object
    @page = page
    @per_page = per_page
  end

  def self.query_objects
    QUERY_OBJECTS
  end

  def self.call(query, query_object, page= '1', per_page ='20')
    new(query, query_object, page, per_page).call
  end

  def call
    return ThinkingSphinx.search(@query, page: @page, per_page: @per_page) if @query_object == 'all'

    @query_object.constantize.search(@query, page: @page, per_page: @per_page)
  end
end