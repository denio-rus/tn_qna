FactoryBot.define do
  factory :comment do
    user
    sequence(:body) { |n| "My interesting comment - #{n}" }
    for_question

    trait :for_question do
      association(:commentable, factory: :question)
    end

    trait :for_answer do
      association(:commentable, factory: :answer)
    end

    trait :invalid do
      body { nil }
    end
  end
end
