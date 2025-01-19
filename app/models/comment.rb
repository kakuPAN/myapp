class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  validates :body, presence: true
  validates :body, length: { maximum: 100 }

  def comment_page
  end
end
