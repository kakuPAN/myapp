class Frame < ApplicationRecord
  belongs_to :board
  has_many :board_logs, dependent: :destroy
  has_many :frame_logs, through: :board_logs, source: :user
  has_one_attached :image

  validates :board_id, presence: true
  validates :body, length: { maximum: 500 }, allow_nil: true
  validates :frame_number, presence: true, uniqueness: { scope: :board_id }
  validates :frame_type, presence: true

  validate :body_or_image_presence
  validate :image_content_type
  validate :image_size
  validate :frame_type_check

  enum :frame_type, { text_frame: 0, image_frame: 1 }

  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:base, "ファイル形式が、JPEG, JPG, PNG以外になっています")
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 200.kilobytes
      errors.add(:base, "200KB以下のファイルをアップロードしてください")
    end
  end

  def frame_type_check
    if image.attached? && text_frame?
      errors.add(:base, "画像ファイルを設定してください")
    elsif body.present? && image_frame?
      errors.add(:base, "本文を入力してください")
    end
  end

  private

  def body_or_image_presence
    if body.blank? && !image.attached?
      errors.add(:base, "本文または画像のどちらかを入力してください")
    elsif body.present? && image.attached?
      errors.add(:base, "本文と画像の両方を設定することはできません")
    end
  end
end
