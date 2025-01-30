class Admin::FramesController < Admin::BaseController
  before_action :set_board
  before_action :set_frame, only: %i[show destroy]

  def index
    @frames = @board.frames.order(frame_number: :asc).page(params[:page]).per(2)
  end

  def show
    @board = @frame.board
  end

  def destroy
    if @frame.destroy
      redirect_to admin_board_frames_path(@board)
      flash[:success] = "フレームを削除しました"
    else
      redirect_to admin_board_frame_path(@board, @frame)
      flash[:success] = "フレームを削除できません"
    end
  end

  private

  def set_board
    @board = Board.find_by(id: params[:board_id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to admin_boards_path
    end
  end

  def set_frame
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to admin_board_frames_path(board_id: @board.id)
    end
  end
end
