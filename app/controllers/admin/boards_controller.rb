class Admin::BoardsController < Admin::BaseController
  before_action :set_board, except: [ :index ]

  def index
  end

  def show
  end

  def board_info
    @board_logs = @board.board_logs
      .where.not(action_type: 0)
      .includes(:user, :frame)
      .order(created_at: :desc).page(params[:page]).per(10)
  end

  def destroy
    if @board.destroy
      flash[:success] = "トピックを削除しました"
      redirect_to admin_boards_path
    else
      flash[:danger] = "トピックを削除できません"
      redirect_to admin_board_path(@board)
    end
  end

  private

  def set_board
    @board = Board.find_by(id: params[:id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to admin_boards_path
    end
  end
end
