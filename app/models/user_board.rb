class UserBoard < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :board
end
