class Admin::FramesController < Admin::BaseController
  before_action :set_board
  def index
    @frames = @board.frames.order(frame_number: :asc).page(params[:page]).per(2)
  end

  def show
    @frame = Frame.find(params[:id])
    @board = @frame.board
  end

  def destroy
    @frame = Frame.find(params[:id])
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
    @board = Board.find(params[:board_id])
  end
end