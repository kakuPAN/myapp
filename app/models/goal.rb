class Goal < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :tasks, dependent: :destroy
  has_many :heights, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "title", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end
end
