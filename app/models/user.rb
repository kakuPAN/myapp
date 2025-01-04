class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :tasks, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_one_attached :avater_image

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true
  validate :image_content_type
  validate :image_size

  def image_content_type
    if avater_image.attached? && !avater_image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:avater_image, '：ファイル形式が、JPEG, JPG, PNG以外になってます。ファイル形式をご確認ください。')
    end
  end

  def image_size
    if avater_image.attached? && avater_image.blob.byte_size > 3.megabytes
      errors.add(:avater_image, '：3MB以下のファイルをアップロードしてください。')
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "user_name", "email" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "boards" ]
  end
end
