class Height < ApplicationRecord
  belongs_to :user
  enum :current_height_level, { atom: 0, thing: 1, building: 1, space: 2 }
end
