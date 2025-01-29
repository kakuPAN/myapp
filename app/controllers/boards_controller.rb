class BoardsController < ApplicationController
  before_action :require_login, except: %i[index show board_info]

  def index
    if @index_boards.empty? && @index_boards.current_page > 1 # 表示できるボードが存在しない場合、このコードがないとリダイレクトが繰り返されエラーになる。
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
    @parent_id = @board.parent_id
    @parent_board = Board.find(@parent_id)
    respond_to do |format|
      if @board.save
        @board_logs = BoardLog.create(user_id: current_user.id, board_id: @board.id, action_type: :create_action)
        format.html do
          redirect_to edit_board_path(@board)
          flash[:success] = "ボードを作成しました"
        end
      else
        format.turbo_stream do
          flash.now[:danger] = "入力に不足があります"
        end
      end
    end
  end

  def show
    @board = Board.find_by(id: params[:id])
    if !@board
      redirect_to boards_path
      flash[:danger] = "ボードが存在しません"
      return
    end
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
    @board = Board.find(params[:id])
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

  def edit_board
    @board = Board.find(params[:id])
  end

  def update
    @board = Board.find(params[:id])
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
    @board = Board.find(params[:id])
    @board.destroy
    flash[:success] = "#{@board.title}を削除しました"
    redirect_to boards_path
  end

  def create_like
    @board = Board.find(params[:id])
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
    @board = Board.find(params[:id])
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
    @board = Board.find(params[:id])
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

  def boards_page_for(board) # 詳細ページ上にあるボード一覧の同じページを表示するためのメソッド
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
