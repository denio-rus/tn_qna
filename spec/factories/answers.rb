FactoryBot.define do
  sequence :body do |n|
    "My test answer - #{n}"
  end
  factory :answer do
    body 

    question
    author

    trait :invalid do
      body { nil }
    end

    factory :answer_with_attached_file do
      after(:create) { |answer| answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }
    end
  end
end
