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
    @frame_type = params[:frame_type] || :image
    if @board.frames.size < 4
      @frame = @board.frames.build
    else
      redirect_to edit_board_path(@board)
    end
  end

  def create
    @frame_type = params[:frame_type] || :image
    frame_number = @board.frames.size + 1
    @frame = @board.frames.build(frame_params.merge(frame_number: frame_number))

    if @frame.save
      make_board_private(@board)
      redirect_to edit_board_path(@board)
      flash[:notice] = "フレームが作成されました"
    else
      @frame_type = 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @frame_type = params[:frame_type] || :image
    @frame = @board.frames.find(params[:id])
  end

  def update
    @frame_type = params[:frame_type] || :image
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
    current_number = @frame.frame_number
    @frame.destroy
    begin
      Frame.transaction do
        @frame.destroy
        # 削除された番号より大きな番号を持つフレームを1つずつ繰り下げ
        @board.frames.where('frame_number > ?', current_number).order(:frame_number).each do |frame|
          frame.update!(frame_number: frame.frame_number - 1)
        end
      end
    rescue => e
      flash[:danger] = "フレームを削除できません"
    end
    make_board_private(@board)
    redirect_to edit_board_path(@board)
    flash[:success] = "フレームを削除しました"
  end

  def move_forward
    @frame = Frame.find(params[:id])
    if @frame.frame_number > 1
      previous_frame = @board.frames.find_by(frame_number: @frame.frame_number - 1)

      current_number = @frame.frame_number
      previous_number = current_number-1
      begin 
        Frame.transaction do
          previous_frame.update!(frame_number: 5)
          @frame.update!(frame_number: previous_number)
          previous_frame.update!(frame_number: current_number)
        end
      rescue => e
        flash[:danger] = "フレームを移動できません"
      end
      redirect_to edit_board_path(@board)
    else
      redirect_to edit_board_path(@board)
    end
  end

  def move_back
    @frame = Frame.find(params[:id])
    if @frame.frame_number <4
      next_frame = @board.frames.find_by(frame_number: @frame.frame_number + 1)

      current_number = @frame.frame_number
      next_number = current_number+1
      begin 
        Frame.transaction do
          next_frame.update!(frame_number: 5)
          @frame.update!(frame_number: next_number)
          next_frame.update!(frame_number: current_number)
        end
      rescue => e
        flash[:danger] = "フレームを移動できません"
      end
      redirect_to edit_board_path(@board)
    else
      redirect_to edit_board_path(@board)
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
