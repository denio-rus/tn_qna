FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { "" }

  trait :invalid
    body { nil }
  end
end
