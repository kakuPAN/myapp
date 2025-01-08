class BoardsController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :set_search

  def index
    if params[:current_board_id] # 他のページから一覧ページのリンクをクリックした場合に、同じ投稿が表示されるページにアクセスするための処理
      current_board = Board.find(params[:current_board_id])
      @page = all_boards_page_for(current_board)
      redirect_to boards_path(page: @page) and return
    end
    
    if @index_boards.empty? && @index_boards.current_page > 1 # 表示できる投稿が存在しない場合、このコードがないとリダイレクトが繰り返されエラーになる。
      redirect_to boards_path(page: @index_boards.total_pages) and return
    end
  end
  
  def new
    @board = Board.new
  end

  def create
    @board = Board.new(board_params.merge(user_id: current_user.id))
    if @board.save
      redirect_to edit_board_path(@board)
      flash[:success] = "投稿を作成しました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @board = Board.find_by(id: params[:id])
    
    if !@board  || @board.access_level == 0 && @board.user_id != current_user&.id
      redirect_to boards_path
      flash[:danger] = "投稿が存在しません"
      return 
    end

    @visitor = UserBoard.find_by(user_id: current_user, board_id: @board.id)
    if @visitor&.unvisited?
      @visitor.update(trigger: 1)
    elsif @visitor&.answering?
      @visitor.update(trigger: 2)
    end
    
    @frames = Frame.where(board_id: @board.id).order(:frame_number)
    @pagination_context == :index
    @page = user_boards_page_for(@board)
    
    if @board.user_id == current_user&.id
      @boards= Board.where(user_id: @board.user_id).order(created_at: :desc).page(@page).per(3) # 後、comment_countカラムを追加し、コメントの数またはリアクションの数でソート
    # １ページに表示する個数を変えた場合、page_forメソッドも変更すること
    else
      @boards= Board.where("user_id = ? AND access_level = ?", @board.user_id, 1).order(created_at: :desc).page(@page).per(3)
    end
    @recommend_boards = Board.where(access_level: 1).where.not(id: @board.id).all # 実際は、誰がどの投稿にリアクション・コメント・閲覧したかを確認できるテーブルを用意し、そこから取得
    @comment = Comment.new

    if @boards.out_of_range? # Kaminari の out_of_range? メソッドを使用
      redirect_to boards_path(page: @boards.total_pages) and return
    end
  end

  def answer
    @board = Board.find(params[:id])
    if current_user && @board.user_id != current_user.id
      UserBoard.find_or_create_by(user: current_user, board: @board)
    end
    redirect_to board_path(@board)
    flash[:info] = "30秒以内に回答してください"
  end

  def edit
    @board = Board.find_by(id: params[:id])
    @frames = @board.frames.order(:frame_number)
    if @board
      @board
    else
      redirect_to boards_path
      flash.now[:danger] = "ボードが見つかりませんでした。"
      return
    end
    if @board && current_user&.id == @board.user_id
      @board
    else
      redirect_to boards_path
      flash[:danger] = "投稿が存在しません"
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to boards_path # 後、マイページの投稿一覧に変更
  end

  def make_board_publish
    @board = Board.find(params[:id])
    @board.update(access_level: 1)
    flash[:success] =  "投稿を公開しました"
    redirect_to edit_board_path(@board)
  end

  def make_board_private
    @board = Board.find(params[:id])
    @board.update(access_level: 0)
    flash[:success] =  "投稿を非公開にしました"
    redirect_to edit_board_path(@board)
  end

  private

  def board_params
    params.require(:board).permit(:title)
  end

  def set_search
    @index_page = params[:page].to_i # 不正なページ番号を補正（0以下の値や文字列を1にする）
    @index_page = 1 if @index_page < 1
    if current_user
      @q = Board.where("access_level = ? OR user_id = ?", 1, current_user.id).ransack(params[:q])
    else
      @q = Board.where(access_level: 1).ransack(params[:q])
    end
    @index_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(@index_page).per(2)
  end

  def all_boards_page_for(board) #詳細ページから一覧ページに戻る際に、同じ投稿が表示されるページにアクセスするためのメソッド
    per_page = 3
    boards = Board.order(created_at: :desc).pluck(:id) #表示順序によって変更が必要
    board_index = boards.index(board.id)
    (board_index / per_page) + 1
  end

  def user_boards_page_for(board) # 詳細ページ上にある同じ投稿者の投稿一覧をの同じページを表示するためのメソッド
    per_page = 3
    boards = Board.where(user_id: board.user_id).order(created_at: :desc).pluck(:id) #表示順序によって変更が必要
    board_index = boards.index(board.id)
    (board_index / per_page) + 1
  end
end
