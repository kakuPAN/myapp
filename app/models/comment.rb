class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :children, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy
  has_many :reports, dependent: :destroy

  validates :user_id, presence: true
  validates :board_id, presence: true
  validates :body, presence: true
  validates :body, length: { maximum: 100 }
end
