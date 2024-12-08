class Task < ApplicationRecord
  belongs_to :user
  enum :access_level, { private_access: 0, public_access: 1 }
  enum :progress_status, { not_started: 0, in_progress: 1, done: 2 }

  validates :title, presence: true
  validates :body, presence: true
  validates :access_level, presence: true
  validates :progress_status, presence: true

  def self.calcurate_achievement_rate
    start_of_today = Time.current.beginning_of_day
    end_of_today = Time.current.end_of_day

    today_tasks = Task.where(deadline: start_of_today..end_of_today)
    all_tasks_count = today_tasks.count
    return 0 if all_tasks_count.zero?

    done_today_tasks = today_tasks.where(progress_status: :done)
    done_tasks_count = done_today_tasks.count

    achievement_rate = (done_tasks_count.to_f/all_tasks_count)*100
    achievement_rate.to_i
  end

  def self.progress_statuses_i18n
    {
      "done" => I18n.t("enums.task.progress_status.done"),
      "in_progress" => I18n.t("enums.task.progress_status.in_progress"),
      "not_started" => I18n.t("enums.task.progress_status.not_started")
    }
  end

  def self.ransackable_attributes(auth_object = nil)
    # 検索可能にしたい属性を配列で返す
    [ "access_level", "body", "deadline", "progress_status", "title", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end
end
