class UserBoard < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :board

  validates :board_id, presence: true
end
