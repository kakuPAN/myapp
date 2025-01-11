class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :likes, dependent: :destroy
  has_many :liked_boards, through: :likes, source: :board
  has_many :user_boards
  has_many :visit_boards, through: :user_boards, source: :board
  has_many :tasks, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_one_attached :avatar_image

  validates :user_name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 250 }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  
  validate :image_content_type
  validate :image_size

  def image_content_type
    if avatar_image.attached? && !avatar_image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:avatar_image, '：ファイル形式が、JPEG, JPG, PNG以外になってます。ファイル形式をご確認ください。')
    end
  end

  def image_size
    if avatar_image.attached? && avatar_image.blob.byte_size > 3.megabytes
      errors.add(:avatar_image, '：3MB以下のファイルをアップロードしてください。')
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "user_name", "email" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "boards" ]
  end
end
