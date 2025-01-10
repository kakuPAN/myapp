class Board < ApplicationRecord
  belongs_to :parent, class_name: 'Board', optional: true
  has_many :children, class_name: 'Board', foreign_key: 'parent_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :frames, dependent: :destroy
  has_many :user_boards
  has_many :visit_users, through: :user_boards, source: :user

  validates :title, presence: true, length: { maximum: 100 }
  validates :title, uniqueness: { scope: :parent_id, message: "は同じ親ノード内で一意である必要があります" }


  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "title" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end

  def breadcrumbs
    crumbs = []
    current_node = self

    while current_node
      crumbs.unshift(current_node) # 現在のノードをリストの先頭に追加
      current_node = current_node.parent # 親ノードへ移動
    end

    crumbs
  end
end
