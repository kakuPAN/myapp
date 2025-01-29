class Admin::BoardsController < Admin::BaseController

  def index
  end

  def show
    @board = Board.find(params[:id])
  end
  
  def board_info
    @board = Board.find(params[:id])
    @board_logs = @board.board_logs
      .where.not(action_type: 0)
      .includes(:user, :frame)
      .order(created_at: :desc)
  end

  def destroy
    @board = Board.find(params[:id])
    if @board.destroy
      flash[:success] = "トピックを削除しました"
      redirect_to admin_boards_path
    else
      flash[:danger] = "トピックを削除できません"
      redirect_to admin_board_path(@board)
    end
  end
end