class BoardsController < ApplicationController
  before_action :require_login, except: %i[index show]
  def index
    @all_boards = Board.all
    @boards= Board.order(created_at: :desc).page(params[:page]).per(1)
  end

  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params.merge(user_id: current_user.id))
    if @board.save
      redirect_to @board
      flash[:success] = "投稿を作成しました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find(params[:id])
  end

  def edit
    @board = Board.find(params[:id])
    if @board && current_user&.id == @board.user_id
      @board
    else
      redirect_to boards_path
      flash[:danger] = "タスクが存在しません"
    end
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to board_path(@board)
      flash[:success] = "変更内容を保存しました"
    else
      flash.now[:danger] = "変更を保存できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to boards_path
  end

  def delete_image
    @board = Board.find(params[:id])
    @board.image.purge
    respond_to do |format|
        render turbo_stream: turbo_stream.remove(@board.image)
    end
  end

  private

  def board_params
    params.require(:board).permit(:id , :user_id, :body, :image, images: [])
  end

end
