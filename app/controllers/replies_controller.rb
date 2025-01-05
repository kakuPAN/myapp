class RepliesController < ApplicationController
  before_action :require_login
  before_action :set_search
  before_action :set_variables

  def new
    @reply = @reply_comment.replies.build
    @context = :reply
    render "boards/show"
  end

  def create
    @reply = @reply_comment.replies.new(reply_params.merge(user_id: current_user.id))
    @context = :reply
    if @reply.save
      redirect_to board_path(@board)
      flash[:success] = "コメントに返信しました"
    else
      flash.now[:danger] = "コメントを作成できません"
      render "boards/show", status: :unprocessable_entity
    end
  end

  private

  def reply_params
    params.require(:reply).permit(:body)
  end

  def set_variables
    @reply_comment = Comment.find(params[:comment_id])
    @board = Board.find(@reply_comment.board_id)
    @frames = Frame.where(board_id: @board.id).order(:frame_number)
    @comment = Comment.new
    @pagination_context == :index
    @page = user_boards_page_for(@board)
    
    if @board.user_id == current_user&.id
      @boards= Board.where(user_id: @board.user_id).order(created_at: :desc).page(@page).per(3) # 後、comment_countカラムを追加し、コメントの数またはリアクションの数でソート
    else
      @boards= Board.where("user_id = ? AND access_level = ?", @board.user_id, 1).order(created_at: :desc).page(@page).per(3)
    end
    @recommend_boards = Board.where(access_level: 1).where.not(id: @board.id).all # 実際は、誰がどの投稿にリアクション・コメント・閲覧したかを確認できるテーブルを用意し、そこから取得
  end

  def set_search
    @index_page = params[:page].to_i
    @index_page= 1 if @index_page < 1
    if current_user
      @q = Board.where("access_level = ? OR user_id = ?", 1, current_user.id).ransack(params[:q])
    else
      @q = Board.where(access_level: 1).ransack(params[:q])
    end
    @index_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(@index_page).per(2)
  end

  def user_boards_page_for(board) # 詳細ページ上にある同じ投稿者の投稿一覧をの同じページを表示するためのメソッド
    per_page = 3
    boards = Board.where(user_id: board.user_id).order(created_at: :desc).pluck(:id) #表示順序によって変更が必要
    board_index = boards.index(board.id)
    (board_index / per_page) + 1
  end
end
