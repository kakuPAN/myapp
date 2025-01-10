class CommentsController < ApplicationController
  before_action :require_login
  before_action :set_search

  def index
    @board = Board.find(params[:board_id])
    @comments = @board.comments.order(created_at: :desc).page(params[:page]).per(10)
    @comment = Comment.new
    @reply = Reply.new
  end

  def create
    @board = Board.find(params[:board_id]) # どの投稿にコメントするかを特定
    @comment = @board.comments.build(comment_params) # コメントを投稿に関連付け
    @comment.user = current_user # ユーザーがログインしている場合に関連付け

    if @comment.save
      redirect_to request.referer || boards_path(@board)
    else
      redirect_to request.referer || boards_path(@board)
    end
  end

  def reply_form
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    @reply = @comment.replies.build
    respond_to do |format|
      format.js {}
      format.html
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body) # フォームから送信されたパラメータを許可
  end

  def set_search
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = Board.ransack(params[:q])
    @index_boards = @q.result(distinct: true).order(created_at: :desc).page(@index_page).per(10)
  end
end
