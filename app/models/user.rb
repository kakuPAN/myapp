class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

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
  validates :email, presence: true, uniqueness: true
  validate :image_content_type
  validate :image_size

  before_destroy :check_admin_count
  
  enum :role, { general: 0, admin: 1 }

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "user_name" ]
  end

  def avatar_image_webp
    avatar_image.variant(format: :webp).processed
  end

  def image_content_type
    if avatar_image.attached? && !avatar_image.content_type.in?(%w[image/jpeg image/jpg image/png image/webp])
      errors.add(:base, "ファイル形式が、JPEG, JPG, PNG, WEBP以外になっています")
    end
  end

  def image_size
    if avatar_image.attached? && avatar_image.blob.byte_size > 200.kilobytes
      errors.add(:base, "200KB以下のファイルをアップロードしてください")
    end
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.assign_attributes(
      user_name: auth.info.name,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    )
    user.role = 1 if auth.info.email == Rails.application.credentials.dig(:admin, :email) # []はCIでエラーになる
    begin
      user.save!
      user
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "OmniAuth authentication failed: #{e.message}"
      nil
    end
  end

  private

  def check_admin_count
    if admin? && User.where(role: "admin").count == 1
      throw :abort
    end
  end
end
