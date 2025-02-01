module CommentsHelper
  def board_image(board)
    board.frames.limit(10).find { |frame| frame.image.attached? }
  end

  def comment_page_for(comment, comments_per_page = 2)
    # コメントが属するトピックのすべてのコメントを、ページネーション順で取得
    comments = comment.board.comments.order(created_at: :desc).pluck(:id)

    # コメントが配列内の何番目にあるかを取得
    comment_index = comments.index(comment.id)

    # 配列内に存在しない場合は nil を返す
    return nil unless comment_index

    # ページ番号を計算（0-based index を 1-based に変換）
    (comment_index / comments_per_page) + 1
  end
end
