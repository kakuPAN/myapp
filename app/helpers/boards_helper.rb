module BoardsHelper
  def page_for(board) #詳細ページから一覧ページに戻る際に、同じ投稿が表示されるページにアクセスするためのメソッド
    # 1ページあたりの投稿数
    per_page = 8
    # 投稿の全体の並び順を取得
    boards = Board.order(created_at: :desc).pluck(:id) #表示順序によって変更が必要
    # 対象の投稿の、並び替えた投稿の中のインデックス番号を取得
    board_index = boards.index(board.id)
    # ページ番号を計算
    (board_index / per_page) + 1
  end

  def board_check(board)
    if board.user_id == current_user&.id
      boards = Board.where(user_id: board.user_id).order(created_at: :desc).pluck(:id)
    else
      boards = Board.where("user_id = ? AND access_level = ?", board.user_id, 1).order(created_at: :desc).pluck(:id)
    end

    return nil if boards.blank? || !boards.include?(board.id)
    board_index = boards.index(board.id)
    return boards, board_index
  end
  
  def latest_board(board)
    boards, board_index = board_check(board) 
    if board_index == 0
      nil
    else
      latest_board_id = boards.first
    end
  end

  def previous_board(board)
    boards, board_index = board_check(board) 
    if board_index == 0
      nil
    else
    # 前のボードのIDを返す
      previous_board_id = boards[board_index - 1]
    end
  end

  def next_board(board)
    boards, board_index = board_check(board) 
    if board_index == boards.length - 1
      nil
    else
    # 次のボードのIDを返す
      next_board_id = boards[board_index + 1]
    end
  end

  def oldest_board(board)
    boards, board_index = board_check(board) 
    if board_index == boards.length - 1
      nil
    else
      oldest_board_id = boards.last
    end
  end
end
