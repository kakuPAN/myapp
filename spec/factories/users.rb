FactoryBot.define do
  factory :user do
    user_name { "user" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    role { 0 }
  end
end
