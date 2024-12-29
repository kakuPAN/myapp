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

  def previous_board(board)
    boards = Board.where(user_id: board.user_id).order(created_at: :desc).pluck(:id)
    if boards.first == board.id
      nil
    else
      board_index = boards.index(board.id)
      previous_board_id = boards[board_index - 1]
    end
  end

  def next_board(board)
    boards = Board.where(user_id: board.user_id).order(created_at: :desc).pluck(:id)
    if boards.last == board.id
      nil
    else
      board_index = boards.index(board.id)
      next_board_id = boards[board_index + 1]
    end
  end
end
