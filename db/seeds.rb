# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ActiveJob::Base.queue_adapter = :test

%w[dan vasya felix margo nick admin].each { |name| User.create(email: "#{name}@sdfmsmfkl.com", password: "123456", confirmed_at: Time.current) }

User.where(email: "admin@sdfmsmfkl.com").first.update(admin: true)

THEMES = %w[maths Spanish pirates credits Ruby Rails health chess dogs].freeze
ADJ = %w[nice awful bad good awesome].freeze

users = User.all

users.each do |u| 
  rand(2..3).times do
    theme = THEMES.sample
    u.questions.create(title: "#{u.email} asking about #{theme}",
      body: "I have some problem with #{ADJ.sample} #{theme}. Please help")
  end
end

questions = Question.all
questions.each do |q|
  rand(1..3).times { q.answers.create(body: "I have #{ADJ.sample} solution for you", author: users.sample) }
end

posts = (questions + Answer.all)

15.times { posts.sample.comments.create(author: users.sample, body: "IMHO it's #{ADJ.sample}") }

ActiveJob::Base.queue_adapter = :sidekiq

