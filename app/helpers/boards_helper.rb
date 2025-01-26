module BoardsHelper
  def page_for(board) # 詳細ページから一覧ページに戻る際に、同じ投稿が表示されるページにアクセスするためのメソッド
    # 1ページあたりの投稿数
    per_page = 8
    # 投稿の全体の並び順を取得
    boards = Board.order(created_at: :desc).pluck(:id) # 表示順序によって変更が必要
    # 対象の投稿の、並び替えた投稿の中のインデックス番号を取得
    board_index = boards.index(board.id)
    # ページ番号を計算
    (board_index / per_page) + 1
  end

  def board_color(board)
    color_type = board.id % 6
    if color_type == 1
      color_name = "red"
    elsif color_type == 2
      color_name = "green"
    elsif color_type == 3
      color_name = "blue"
    elsif color_type == 4
      color_name = "brown"
    else
      color_name = "emerald"
    end
    color_name
  end

  def board_image(board)
    board.frames.limit(30).find { |frame| frame.image.attached? }
  end


  # def board_check(board)
  #   parent_board = Board.find_by(id: board.parent_id)
  #   return nil if (parent_board.blank? || !parent_board.include?(board.id)) && !parent_board&.children&.empty?
  #   boards = parent_board.children.order(created_at: :desc).pluck(:id)
  #   board_index = boards.index(board.id)
  #   return boards, board_index
  # end

  # def latest_board(board)
  #   boards, board_index = board_check(board)
  #   if board_index == 0
  #     nil
  #   else
  #     latest_board_id = boards.first
  #   end
  # end

  # def previous_board(board)
  #   boards, board_index = board_check(board)
  #   if board_index == 0
  #     nil
  #   else
  #   # 前のボードのIDを返す
  #     previous_board_id = boards[board_index - 1]
  #   end
  # end

  # def next_board(board)
  #   boards, board_index = board_check(board)
  #   if board_index == boards.length - 1
  #     nil
  #   else
  #   # 次のボードのIDを返す
  #     next_board_id = boards[board_index + 1]
  #   end
  # end

  # def oldest_board(board)
  #   boards, board_index = board_check(board)
  #   if board_index == boards.length - 1
  #     nil
  #   else
  #     oldest_board_id = boards.last
  #   end
  # end

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
