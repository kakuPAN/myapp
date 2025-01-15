class BoardsController < ApplicationController
  before_action :require_login, except: %i[index show board_info]

  def index
    if @index_boards.empty? && @index_boards.current_page > 1 # 表示できる投稿が存在しない場合、このコードがないとリダイレクトが繰り返されエラーになる。
      redirect_to boards_path(page: @index_boards.total_pages) and return
    end
  end
  
  def new
    @parent_id = params[:parent_board]
    @parent_board = Board.find(@parent_id)
    @board = Board.new
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :create_action)
      redirect_to edit_board_path(@board)
      flash[:success] = "投稿を作成しました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find_by(id: params[:id])
    @visitor = UserBoard.create(board_id: @board.id)
    if !@board
      redirect_to boards_path
      flash[:danger] = "投稿が存在しません"
      return 
    end
    @same_title_boards = Board.where(title: @board.title)
    @breadcrumbs = @board.breadcrumbs
    @visitor_count = UserBoard.where(board_id: @board.id).count

    if current_user
      @visitor.user_id = current_user.id
      @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :view_action)
    end

    @frames = Frame.where(board_id: @board.id).order(:frame_number)

    @page = boards_page_for(@board)
    @boards = Board.where(parent_id: @board).order(created_at: :desc).page(@page).per(10)

    @comment = Comment.new
  end

  def edit
    @board = Board.find_by(id: params[:id])
    @frames = @board.frames.order(:frame_number)
    @parent_board = Board.find_by(id: @board.parent_id)

    if @board
      @board
    else
      if @parent_board
        redirect_to board_path(@parent_board)
      else
        redirect_to root_path
      end
      flash.now[:danger] = "#{@board.title}が見つかりませんでした。"
    end
  end

  def update
    @board = Board.find_by(id: params[:id])
    @frames = @board.frames.order(:frame_number)
    if @board.update(board_params)
      @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :update_action)
      redirect_to edit_board_path(@board)
      flash[:success] = "タイトルを変更しました"
    else
      render :edit
      flash[:danger] = "タイトルを変更できません"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    flash[:success] = "#{@board.title}を削除しました"
    redirect_to boards_path # 後、マイページの投稿一覧に変更
  end

  def create_like
    @board = Board.find(params[:id])
    @like = @board.likes.new(user_id: current_user.id)
    @like.save
  end

  def destroy_like
    @board = Board.find(params[:id])
    @like = @board.likes.find_by(user_id: current_user.id)
    @like.destroy
  end

  def create_chat
    @board = Board.find(params[:id])
    @comment = @board.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def board_info
    @board = Board.find(params[:id])
    @board_logs = @board.board_logs
      .where.not(action_type: 0)
      .includes(:user, :frame)
      .order(created_at: :desc)
  end

  private

  def board_params
    params.require(:board).permit(:title, :parent_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_breadcrumbs
    add_breadcrumb("HOME", root_path)
  end

  def boards_page_for(board) # 詳細ページ上にある投稿一覧の同じページを表示するためのメソッド
    per_page = 10
    parent_board = Board.find_by(id: board.parent_id)
    if parent_board && !parent_board.children.empty?
      boards = parent_board.children.order(created_at: :desc).pluck(:id)# 表示順序によって変更が必要
      board_index = boards.index(board.id)
      (board_index / per_page) + 1
    else
      1
    end
  end
end
