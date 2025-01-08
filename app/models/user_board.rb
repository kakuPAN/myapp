class UserBoard < ApplicationRecord
  belongs_to :user
  belongs_to :board

  enum :trigger, { unvisited: 0, answering: 1, visited: 2}
end
