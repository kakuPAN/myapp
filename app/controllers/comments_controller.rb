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
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
    @reply = Reply.new(comment_id: @comment.id)
  end

  def destroy
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to board_comment_path(@board)
  end

  def create_reply
    @comment = Comment.find(params[:id])
    @board = Board.find(@comment.board_id)
    @reply = @comment.replies.new(reply_params.merge(user_id: current_user.id))
    @reply.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body) # フォームから送信されたパラメータを許可
  end
  
  def reply_params
    params.require(:reply).permit(:body)
  end

  def set_search
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = Board.ransack(params[:q])
    @index_boards = @q.result(distinct: true).order(created_at: :desc).page(@index_page).per(10)
  end
end
