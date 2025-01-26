class SecurityQuestion < ApplicationRecord
  has_many :users
  validates :question_text, presence: true
end
