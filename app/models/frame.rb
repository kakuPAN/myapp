class Frame < ApplicationRecord
  belongs_to :board
  has_many :board_logs, dependent: :destroy
  has_many :frame_logs, through: :board_logs, source: :user
  has_one_attached :image
  has_rich_text :content
  
  validate :content_length
  validates :board_id, presence: true
  # validates :body, length: { maximum: 500 }, allow_nil: true
  validates :frame_number, presence: true, uniqueness: { scope: :board_id }
  validates :frame_type, presence: true

  validate :content_or_image_presence
  validate :image_content_type
  validate :image_size
  validate :content_length
  enum :frame_type, { text_frame: 0, image_frame: 1 }

  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:base, "ファイル形式が、JPEG, JPG, PNG以外になっています")
    end
  end

  def content_length
    return if content.blank?
    if content.body&.to_plain_text&.length > 1000
      errors.add(:content, "本文は1000文字以内で入力してください")
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 200.kilobytes
      errors.add(:base, "200KB以下のファイルをアップロードしてください")
    end
  end

  private

  def content_or_image_presence
    if frame_type == "text_frame" && content.body.blank?
      errors.add(:base, "本文を入力してください")
    elsif frame_type == "image_frame" && !image.attached?
      errors.add(:base, "画像ファイルを選択してください")
    end
  end
end
