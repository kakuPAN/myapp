module CommentsHelper

  def board_image(board)
    board.frames.limit(10).find { |frame| frame.image.attached? }
  end
end
