FactoryBot.define do
  factory :reward do
    title { "MyReward" }
    question 
    user { nil }

    after(:create) { |reward| reward.image.attach(io: File.open("#{Rails.root}/app/assets/images/cup.jpg"), 
                                                  filename: 'cup.jpg', content_type: 'image/jpg') }
  end
end
