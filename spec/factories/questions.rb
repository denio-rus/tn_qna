FactoryBot.define do
  sequence :title do |n|
    "Test question - #{n}"
  end
  factory :question do
    title 
    body { "MyText" }
    
    author

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      transient do
        answers_count { 5 }
      end
    
      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
