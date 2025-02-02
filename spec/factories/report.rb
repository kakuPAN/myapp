FactoryBot.define do
  factory :report do
    association :user
    association :board
    association :comment
    body { "報告内容" }
  end
end
