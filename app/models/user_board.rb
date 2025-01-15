class UserBoard < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :board
  enum :trigger, { unvisited: 0, visited: 1}
end
