FactoryBot.define do
  factory :task do
    title { Faker::Job.title }
    body { Faker::Job.field }
    deadline { "2024/12/24 12:00" }
    access_level { 1 }
    association :user
  end
end
