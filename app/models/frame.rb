class Frame < ApplicationRecord
  belongs_to :board
  has_many :board_logs, dependent: :destroy
  has_many :frame_logs, through: :board_logs, source: :user
  has_one_attached :image

  validates :body, length: { maximum: 500 }, allow_nil: true # content_or_image_presence でnilチェック
  validates :frame_number, presence: true, uniqueness: { scope: :board_id }
  validate :body_or_image_presence
  validate :image_content_type
  validate :image_size

  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:image, '：ファイル形式が、JPEG, JPG, PNG以外になってます。ファイル形式をご確認ください。')
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 3.megabytes
      errors.add(:image, '：3MB以下のファイルをアップロードしてください。')
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
