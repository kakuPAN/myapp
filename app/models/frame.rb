class Frame < ApplicationRecord
  belongs_to :board
  has_many :board_logs, dependent: :destroy
  has_many :frame_logs, through: :board_logs, source: :user
  has_one_attached :image

  validates :body, length: { maximum: 500 }, allow_nil: true
  validates :frame_number, presence: true, uniqueness: { scope: :board_id }
  validate :image_content_type
  validate :image_size

  enum :frame_type, { text_frame: 0, image_frame: 1 }

  def image_content_type
    if image.attached? && !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:base, 'ファイル形式が、JPEG, JPG, PNG以外になっています。')
    end
  end

  def image_size
    if image.attached? && image.blob.byte_size > 3.megabytes
      errors.add(:base, '3MB以下のファイルをアップロードしてください。')
    end
  end

  private

end
