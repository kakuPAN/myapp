class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_boards, through: :likes, source: :board
  has_many :user_boards, dependent: :destroy
  has_many :visited_boards, through: :user_boards, source: :board
  has_many :board_logs, dependent: :destroy
  has_many :user_board_actions, through: :board_logs, source: :board
  has_many :user_frame_actions, through: :board_logs, source: :frame
  has_many :reports, dependent: :destroy
  has_one_attached :avatar_image

  validates :uid, uniqueness: { scope: :provider }
  validates :user_name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 250 }
  # validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  # validates :password, length: { maximum: 50 }, if: -> { new_record? || changes[:crypted_password] }
  # validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  # validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true

  validate :image_content_type
  validate :image_size

  enum :role, { general: 0, admin: 1 }

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "user_name" ]
  end

  def image_content_type
    if avatar_image.attached? && !avatar_image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:base, "ファイル形式が、JPEG, JPG, PNG以外になっています")
    end
  end

  def image_size
    if avatar_image.attached? && avatar_image.blob.byte_size > 200.kilobytes
      errors.add(:base, "200KB以下のファイルをアップロードしてください")
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end
  
  def self.create_unique_string
    SecureRandom.uuid
  end
end
