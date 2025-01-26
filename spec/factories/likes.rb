FactoryBot.define do
  factory :like do
    association :user
    association :board
  end
end
