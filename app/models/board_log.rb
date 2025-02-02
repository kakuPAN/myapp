class BoardLog < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :frame, optional: true

  enum :action_type, { view_action: 0, create_action: 1, update_action: 2 }

  validates :user_id, presence: true
  validates :board_id, presence: true
  validates :action_type, presence: true
end
