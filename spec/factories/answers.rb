FactoryBot.define do
  factory :answer do
    body { "MyText-Answer" }

    question
    author

    trait :invalid do
      body { nil }
    end
  end
end
