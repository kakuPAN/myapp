FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:user_name) { |n| "TestUser#{n}" }
    profile { "テストプロフィール" }
    role { 0 }
    password { "password123" }
    password_confirmation { "password123" }

    trait :admin do
      role { 1 }
    end

    trait :with_google do
      provider { "google_oauth2" }
      uid { Faker::Internet.uuid }
    end
  end
end

