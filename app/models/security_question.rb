class SecurityQuestion < ApplicationRecord
  has_many :users
  validates :question_text, presence: true
  validates :question_text, length: { maximum: 100 }
end
