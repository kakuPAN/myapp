class Report < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :comment, optional: true

  validates :user_id, presence: true
  validates :board_id, presence: true
  validates :body, presence: true, length: { maximum: 500 }
end
