module StaticPagesHelper
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
end