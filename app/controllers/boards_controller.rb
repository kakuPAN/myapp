class BoardsController < ApplicationController
  before_action :require_login, except: %i[index show]
  def index
    if params[:current_board_id] # 他のページから一覧ページのリンクをクリックした場合に、同じ投稿が表示されるページにアクセスするための処理
      current_board = Board.find(params[:current_board_id])
      @page = page_for(current_board)
      redirect_to boards_path(page: @page) and return
    end

    @all_boards = Board.all
    @boards= Board.order(created_at: :desc).page(params[:page]).per(1) #comment_countカラムを追加し、コメントの数またはリアクションの数でソート
    @comment = Comment.new
    
    if @boards.out_of_range? # Kaminari の out_of_range? メソッドを使用
      redirect_to boards_path(page: @boards.total_pages) and return
    end
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
      flash[:danger] = "投稿が存在しません"
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

  def page_for(board) #詳細ページから一覧ページに戻る際に、同じ投稿が表示されるページにアクセスするためのメソッド
    # 1ページあたりの投稿数
    per_page = 1
    # 投稿の全体の並び順を取得
    boards = Board.order(created_at: :desc).pluck(:id) #表示順序によって変更が必要
    # 対象の投稿の、並び替えた投稿の中のインデックス番号を取得
    board_index = boards.index(board.id)
    # ページ番号を計算
    (board_index / per_page) + 1
  end
end
