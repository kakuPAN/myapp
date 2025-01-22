FactoryBot.define do
  factory :frame do
    body { Faker::Lorem.sentence }
    frame_number { Faker::Number.between(from: 1, to: 10) }
    frame_type { 0 } 
    association :board
  end
end
