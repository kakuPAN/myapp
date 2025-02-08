class FramesController < ApplicationController
  before_action :authenticate
  before_action :set_board

  def index
    @frames = Frame.where(board_id: @board.id)
  end

  def new
    @frame_type = params[:frame_type].to_i
    @frame = @board.frames.build(frame_type: @frame_type)
  end

  def create
    frame_number = @board.frames.size + 1
    @frame_type = params[:frame_type].to_i
    @frame = @board.frames.build(frame_params.merge(frame_number: frame_number))
    respond_to do |format|
      if @frame.save
        @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, frame_id: @frame.id, action_type: :create_action)
        format.html do
          redirect_to edit_board_path(@board)
          flash[:success] = "フレームが作成されました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "フレームを作成できません"
        end
      end
    end
  end

  def edit
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to edit_board_path(@board)
    end
  end

  def update
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to edit_board_path(@board)
    end
    respond_to do |format|
      if @frame.update(frame_params)
        @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, frame_id: @frame.id, action_type: :update_action)
        format.html do
          redirect_to edit_board_path(@board)
          flash[:success] = "フレームが更新されました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "変更を保存できません"
        end
      end
    end
  end

  def destroy
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to edit_board_path(@board)
    end
    current_number = @frame.frame_number
    @frame.destroy
    begin
      Frame.transaction do
        @frame.destroy
        # 削除された番号より大きな番号を持つフレームを1つずつ繰り下げ
        @board.frames.where("frame_number > ?", current_number).order(:frame_number).each do |frame|
          frame.update!(frame_number: frame.frame_number - 1)
        end
      end
    rescue => e
      flash[:danger] = "フレームを削除できません"
    end
    redirect_to edit_board_path(@board)
    flash[:success] = "フレームを削除しました"
  end

  def move_forward
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to edit_board_path(@board)
    end
    last_frame_number = @board.frames.order(:frame_number).last.frame_number
    if @frame.frame_number > 1
      previous_frame = @board.frames.find_by(frame_number: @frame.frame_number - 1)
      current_number = @frame.frame_number
      previous_number = current_number-1
      begin
        Frame.transaction do
          previous_frame.update!(frame_number: last_frame_number+1)
          @frame.update!(frame_number: previous_number)
          previous_frame.update!(frame_number: current_number)
        end
      rescue => e
        flash[:danger] = "フレームを移動できません"
      end
      redirect_to edit_board_path(@board)
      flash[:success] = "フレームを移動しました"
    else
      redirect_to edit_board_path(@board)
      flash[:success] = "フレームを移動できません"
    end
  end

  def move_back
    @frame = Frame.find_by(id: params[:id])
    unless @frame
      flash[:danger] = "フレームが存在しません"
      redirect_to edit_board_path(@board)
    end
    last_frame_number = @board.frames.order(:frame_number).last.frame_number

    if @frame.frame_number < last_frame_number
      next_frame = @board.frames.find_by(frame_number: @frame.frame_number + 1)

      current_number = @frame.frame_number
      next_number = current_number+1
      begin
        Frame.transaction do
          next_frame.update!(frame_number: last_frame_number+1)
          @frame.update!(frame_number: next_number)
          next_frame.update!(frame_number: current_number)
        end
      rescue => e
        flash[:danger] = "フレームを移動できません"
      end
      redirect_to edit_board_path(@board)
      flash[:success] = "フレームを移動しました"
    else
      redirect_to edit_board_path(@board)
      flash[:success] = "フレームを移動できません"
    end
  end

  private

  def set_board
    @board = Board.find_by(id: params[:board_id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
    end
  end

  def frame_params
    params.require(:frame).permit(:body, :frame_number, :image, :frame_type)
  end
end
