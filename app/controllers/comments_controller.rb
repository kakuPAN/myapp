class CommentsController < ApplicationController
  before_action :require_login

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

  private

  def comment_params
    params.require(:comment).permit(:body) # フォームから送信されたパラメータを許可
  end
end
