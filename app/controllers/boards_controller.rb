class BoardsController < ApplicationController
  before_action :authenticate, except: %i[index show board_info]
  before_action :set_board, except: %i[index new create]

  def index
    if @index_boards.empty? && @index_boards.current_page > 1
      redirect_to boards_path(page: @index_boards.total_pages) and return
    end
  end

  def new
    @parent_id = params[:parent_board]
    @parent_board = Board.find_by(id: @parent_id)
    if @parent_board
      @board = Board.new
    else
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
    end
  end

  def create
    @board = Board.new(board_params)
    @parent_id = @board.parent_id
    @parent_board = Board.find_by(id: @parent_id)
    unless @parent_board
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
      return
    end
    respond_to do |format|
      if @board.save
        @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :create_action)
        format.html do
          redirect_to edit_board_path(@board)
          flash[:success] = "トピックを作成しました"
        end
      else
        format.turbo_stream do
          flash.now[:danger] = "入力に不足があります"
        end
      end
    end
  end

  def show
    @visitor = UserBoard.create(board_id: @board.id)
    @same_title_boards = Board.where(title: @board.title)
    @breadcrumbs = @board.breadcrumbs
    @visitor_count = UserBoard.where(board_id: @board.id).count

    if current_user
      @visitor.update(user_id: current_user.id)
      @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :view_action)
    end

    @frames = Frame.where(board_id: @board.id).order(:frame_number)

    @page = boards_page_for(@board)
    @boards = Board.where(parent_id: @board).order(created_at: :desc).page(@page).per(10)

    @comment = Comment.new
  end

  def edit
    @frames = @board.frames.order(:frame_number)
    @parent_board = Board.find_by(id: @board.parent_id)
  end

  def edit_board
  end

  def update
    @frames = @board.frames.order(:frame_number)
    respond_to do |format|
      if @board.update(board_params)
        @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :update_action)
        format.turbo_stream do
          flash.now[:success] = "タイトルを変更しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "タイトルを変更できません"
        end
      end
    end
  end

  def destroy
    @board.destroy
    flash[:success] = "#{@board.title}を削除しました"
    redirect_to boards_path
  end

  def create_like
    @like = @board.likes.new(user_id: current_user.id)
    respond_to do |format|
      if @like.save
        format.turbo_stream do
          flash.now[:success] = "お気に入りに登録しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "お気に入りに登録できません"
        end
      end
    end
  end

  def destroy_like
    @like = @board.likes.find_by(user_id: current_user.id)
    respond_to do |format|
      if @like.destroy
        format.turbo_stream do
          flash.now[:success] = "お気に入りを解除しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "お気に入りを解除できません"
        end
      end
    end
  end

  def create_chat
    @comment = @board.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to board_path(@board) }
        format.turbo_stream do
          flash.now[:success] = "コメントを作成しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "コメントを作成できません"
        end
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  def board_info
    @board_logs = @board.board_logs
      .where.not(action_type: 0)
      .includes(:user, :frame)
      .order(created_at: :desc)
  end

  private
  def set_board
    @board = Board.find_by(id: params[:id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
    end
  end

  def board_params
    params.require(:board).permit(:title, :parent_id)
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_breadcrumbs
    add_breadcrumb("HOME", root_path)
  end

  def boards_page_for(board) # 詳細ページ上にあるトピック一覧の同じページを表示するためのメソッド
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
