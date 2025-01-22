class Board < ApplicationRecord
  belongs_to :parent, class_name: 'Board', optional: true
  has_many :children, class_name: 'Board', foreign_key: 'parent_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :frames, dependent: :destroy
  has_many :user_boards, dependent: :destroy
  has_many :visited_users, through: :user_boards, source: :user
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :board_logs, dependent: :destroy
  has_many :action_user, through: :board_logs, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :title, uniqueness: { scope: :parent_id, message: "はすでにこのトピック内に存在します" }

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "title" ]
  end

  def breadcrumbs
    crumbs = []
    current_node = self

    while current_node
      crumbs.unshift(current_node)
      current_node = current_node.parent
    end

    crumbs
  end

  def liked_by?(user)
    if user
      likes.where(user_id: user.id).exists?
    else
      nil
    end
  end
end
