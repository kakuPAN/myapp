module RepliesHelper

  def comment_class_name(board, comment) 
    if current_user && current_user.id == comment.user_id
      comment_class_name = "comment_by_current_user"
    elsif comment.user_id == board.user_id
      comment_class_name = "comment_by_board_user"
    else
      comment_class_name = "comment_by_other_user"
    end
  end

  def reply_class_name(board, reply) 
    if current_user && current_user.id == reply.user_id
      reply_class_name = "comment_by_current_user"
    elsif reply.user_id == board.user_id
      reply_class_name = "comment_by_board_user"
    else
      reply_class_name = "comment_by_other_user"
    end
  end
end
