class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  validates :body, presence: true
  validates :body, length: { maximum: 100 }, allow_nil: true
end
