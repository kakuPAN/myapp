class Report < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :comment

  validates :body, presence: true, length: { maximum: 500 }
end
