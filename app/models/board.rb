class Board < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :frames, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }

  enum :access_level, { private_access: 0, public_access: 1 }

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "title" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end
end
