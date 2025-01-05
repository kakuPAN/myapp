class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board
  has_many :replies, dependent: :destroy

  validates :body, presence: true
  validates :body, length: { maximum: 100 }, allow_nil: true

end
