class Admin::CommentsController < Admin::BaseController
  before_action :set_board
  def index
    @comments = @board.comments.includes(:children).order(created_at: :desc).page(params[:page]).per(3)
  end

  def show
    @comment = Comment.find(params[:id])
    @board = @comment.board
  end

  def destroy
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    if @comment.destroy
        flash[:seccess] = "コメントを削除しました"
        redirect_to admin_board_comments_path(@board)
    else
      flash[:seccess] = "コメントを削除できません"
      redirect_to admin_board_comment_path(@board, @comment)
    end
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end
end