class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :tasks, dependent: :destroy

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :user_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "user_name", "email" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "tasks" ]
  end
end
