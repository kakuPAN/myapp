class FramesController < ApplicationController
  before_action :require_login
  before_action :set_board
  before_action :set_search
  before_action :check_frame_limit, only: [:new, :create]

  def index
    @board = Board.find(params[:board_id])
    @frames = Frame.where(board_id: @board.id)
  end

  def new
    @frame = @board.frames.build
  end

  def create
    frame_number = @board.frames.size + 1
    @frame = @board.frames.build(frame_params.merge(frame_number: frame_number))
    if @frame.save
      make_board_private(@board)
      redirect_to edit_board_path(@board)
      flash[:notice] = "フレームが作成されました"
    else
      render :new, status: :unprocessable_entity
      flash.now[:danger] = "変更を保存できません"
    end
  end

  def edit
    @frame = @board.frames.find(params[:id])
  end

  def update
    @frame = @board.frames.find(params[:id])
    if @frame.update(frame_params)
      make_board_private(@board)
      redirect_to edit_board_path(@board)
      flash[:success] = "フレームが更新されました"
    else
      flash.now[:danger] = "変更を保存できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @frame = Frame.find(params[:id])
    @frame.destroy
    if @board.frames.size >= 1
      @board.frames.each do |frame|
        frame.update(frame_number: frame.frame_number-1)
      end
    end
    make_board_private(@board)
    redirect_to edit_board_path(@board)
    flash[:success] = "フレームを削除しました"
  end

  def delete_image
    @frame = Frame.find(params[:id])
    @frame.image.purge
    respond_to do |format|
        render turbo_stream: turbo_stream.remove(@frame.image)
    end
  end

  private

  def make_board_private(board)
    if board.public_access?
      board.update(access_level: 0)
    end
  end

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_search
    @page = params[:page].to_i # 不正なページ番号を補正（0以下の値や文字列を1にする）
    @page = 1 if @page < 1
    if current_user
      @q = Board.where("access_level = ? OR user_id = ?", 1, current_user.id).ransack(params[:q])
    else
      @q = Board.where(access_level: 1).ransack(params[:q])
    end
    @index_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(@page).per(2)
  end

  def frame_params
    params.require(:frame).permit(:body, :frame_number, :image)
  end

  def check_frame_limit
    if @board.frames.size >= 4
      redirect_to edit_board_path(@board)
      flash[:danger] = "フレームは最大４つまでです"
    end
  end
end
