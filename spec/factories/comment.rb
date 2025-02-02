FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.sentence }
    association :board
    association :user
  end
end
