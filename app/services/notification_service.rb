class NotificationService
  def self.call
    new.call
  end

  def call
    send_push_message
  end

  private

  def send_push_message
    today_tasks = user.tasks.where(deadline: Date.today)
    if today_tasks.any?
      task_list = today_tasks.map { |task| "- #{task.name}" }.join("\n")
      message_text = "#{user.user_name}さんの今日のタスク:\n#{task_list}"
    else
      message_text = "#{user.user_name}さん、今日はタスクがありません。"
    end

    message = {
      type: 'text',
      text: message_text
    }

    response = LINE_NOTIFY_CLIENT.broadcast(message)
    Rails.logger.info "Push message response: #{response.inspect}"
  end
end