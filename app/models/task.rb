class Task < ApplicationRecord
  enum access_level: { private_access: 0, public_access: 1 }
  enum progress_status: { new_task: 0, wip: 1, done: 2 }

  
  validates :title, presence: true
  validates :body, presence: true
  validates :access_level, presence: true
  validates :progress_status, presence: true

  belongs_to :user
end
