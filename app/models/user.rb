class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications
  
  belongs_to :security_question

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_boards, through: :likes, source: :board
  has_many :user_boards, dependent: :destroy
  has_many :visited_boards, through: :user_boards, source: :board
  has_many :board_logs, dependent: :destroy
  has_many :user_board_actions, through: :board_logs, source: :board
  has_many :user_frame_actions, through: :board_logs, source: :frame
  has_one_attached :avatar_image
  
  validates :user_name, presence: true, length: { maximum: 20 }
  validates :profile, length: { maximum: 250 }
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, length: { maximum: 50 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :security_question_id, presence: true
  validates :security_answer_digest, presence: true

  validate :image_content_type
  validate :image_size


  def image_content_type
    if avatar_image.attached? && !avatar_image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:base, 'ファイル形式が、JPEG, JPG, PNG以外になっています')
    end
  end

  def image_size
    if avatar_image.attached? && avatar_image.blob.byte_size > 200.kilobytes
      errors.add(:base, '200KB以下のファイルをアップロードしてください')
    end
  end

  def encrypt_security_answer(security_answer)
    self.security_answer_digest = BCrypt::Password.create(security_answer)
  end

  def generate_reset_token
    self.reset_token = SecureRandom.hex(20)
    self.reset_sent_at = Time.current
    save!
  end
end
