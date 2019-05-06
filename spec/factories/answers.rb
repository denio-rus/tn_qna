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
  end
end
