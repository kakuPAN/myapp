class Category < ApplicationRecord
  has_many :goals, dependent: :destroy
  has_many :users
end
