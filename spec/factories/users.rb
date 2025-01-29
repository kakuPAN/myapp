FactoryBot.define do
  factory :user do
    user_name { "user" }
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    role { 0 }
    security_answer_digest { BCrypt::Password.create("回答") }
    association :security_question
  end
end
