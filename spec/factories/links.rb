FactoryBot.define do
  sequence :name do |n|
    "link - #{n}"
  end

  factory :link do
    name 
    url { "http://yandex.ru" }
    for_question

    trait :for_question do
      association(:linkable, factory: :question)
    end

    trait :for_answer do
      association(:linkable, factory: :answer)
    end
  end
end
