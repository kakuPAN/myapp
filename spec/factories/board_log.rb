FactoryBot.define do
  factory :board_log do
    action_type { 0 }
    association :user
    association :board
  end
end