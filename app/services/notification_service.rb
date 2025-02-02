class NotificationService
  def self.call
    new.call
  end

  def call
    # send_push_message
  end

  private

  def send_push_message
    message = {
      type: "text",
      text: "おはよ〜"
    }

    response = LINE_NOTIFY_CLIENT.broadcast(message)
    Rails.logger.info "Push message response: #{response.inspect}"
  end
end
