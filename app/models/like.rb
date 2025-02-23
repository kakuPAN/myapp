class Like < ApplicationRecord
  belongs_to :user
  belongs_to :board

  validates :user_id, presence: true
  validates :board_id, presence: true
  validates :user_id, uniqueness: { scope: :board_id }
end
