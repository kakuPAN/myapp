class RepliesController < ApplicationController
  before_action :require_login
  before_action :set_search

  # def create
  #   @comment = Comment.find(params[:comment_id])
  #   @board = Board.find(@comment.board_id)
  #   @reply = @comment.replies.new(reply_params.merge(user_id: current_user.id))
  #   @breadcrumbs = @board.breadcrumbs
  #   if @reply.save
  #     redirect_to request.referer || board_comments_path(@board)
  #     flash[:success] = "コメントに返信しました"
  #   else
  #     flash.now[:danger] = "コメントを作成できません"
  #     render "comments/index", status: :unprocessable_entity
  #   end
  # end

  private

  

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

  def boards_page_for(board) # 詳細ページ上にある投稿一覧の同じページを表示するためのメソッド
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
