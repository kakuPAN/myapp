FactoryBot.define do
  factory :user do
    user_name { "user" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end