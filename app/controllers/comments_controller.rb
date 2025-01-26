class CommentsController < ApplicationController
  before_action :require_login, except: %i[ index ]

  def index
    @board = Board.find(params[:board_id])
    @comments = @board.comments.where(parent_id: nil).includes(:children).order(created_at: :desc)
    @comment = Comment.new
  end

  def create
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    @comment.save

    respond_to do |format|
      if @comment.save
        format.html { redirect_to board_comments_path(@board) }
        format.turbo_stream { flash.now[:success] = "コメントを作成しました" }
      else
        flash.now[:danger] = "コメントを作成できません"
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
  end

  def update
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    @comments = @board.comments.where(parent_id: nil).includes(:children).order(created_at: :desc)

    respond_to do |format|
      if @comment.update(comment_params.merge(user_id: current_user.id))

        format.html { redirect_to board_comments_path(@board) }
        format.turbo_stream do
          flash.now[:success] = "コメントを編集しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "コメントを編集できません"
        end
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.destroy
        @comments = @board.comments
        format.html { redirect_to board_comments_path(@board) }
        format.turbo_stream do
          flash.now[:success] = "コメントを削除しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "コメントを削除できません"
        end
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def create_reply
    @parent = Comment.find(params[:parent_id])
    @board = Board.find(params[:board_id])
    @comment = @board.comments.build(comment_params)
    @comment.user = current_user
    @comment.parent_id = @parent.id
    respond_to do |format|
      if @comment.save
        format.html { redirect_to board_comments_path(@board) }
        format.turbo_stream do
          flash.now[:success] = "コメントを作成しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "コメントを作成できません"
        end
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end
end
