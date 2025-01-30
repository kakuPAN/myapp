class Admin::CommentsController < Admin::BaseController
  before_action :set_board, only: %i[index destroy]
  before_action :set_comment, only: %i[show destroy]

  def index
    @comments = @board.comments.includes(:children).order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
    @board = @comment.board
  end

  def destroy
    if @comment.destroy
        flash[:seccess] = "コメントを削除しました"
        redirect_to admin_board_comments_path(@board)
    else
      flash[:danger] = "コメントを削除できません"
      redirect_to admin_board_comment_path(@board, @comment)
    end
  end

  private

  def set_board
    @board = Board.find_by(id: params[:board_id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to admin_boards_path
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:danger] = "コメントが存在しません"
      redirect_to admin_board_comments_path(@board)
    end
  end
end