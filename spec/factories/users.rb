FactoryBot.define do
  factory :user do
    user_name { "user" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "complex-password-complex" }
    password_confirmation { "complex-password-complex" }
  end
end
