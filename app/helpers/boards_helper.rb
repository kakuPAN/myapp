module BoardsHelper
  def page_for(board)
    per_page = 8
    boards = Board.order(created_at: :desc).pluck(:id)
    board_index = boards.index(board.id)
    (board_index / per_page) + 1
  end

  def board_image(board)
    board.frames.limit(30).find { |frame| frame.image.attached? }
  end

  def comment_class_name(comment)
    if current_user && current_user.id == comment.user_id
      comment_class_name = "comment_by_current_user"
    else
      comment_class_name = "comment_by_other_user"
    end
    comment_class_name
  end

  def reply_class_name(reply)
    if current_user && current_user.id == reply.user_id
      reply_class_name = "comment_by_current_user"
    else
      reply_class_name = "comment_by_other_user"
    end
    reply_class_name
  end
end
