class CommentsController < ApplicationController
  before_action :require_login, except: %i[ index ]

  def index
    @board = Board.find(params[:board_id])
    @comments = @board.comments.where(parent_id: nil).includes(:children).order(created_at: :desc).page(params[:page]).per(2)
    @comment = Comment.new
  end

  def create
    @parent_id = params[:parent_id]
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent_id
    @comment.save
    @reply = Comment.new(parent_id: @comment.id)
  end

  def destroy
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    @comments = @board.comments

  end

  def create_reply
    @parent = Comment.find(params[:parent_id])
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent.id
    @comment.save
    @reply = Comment.new(parent_id: @comment.id)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end
  
  def reply_params
    params.require(:reply).permit(:body)
  end
end
