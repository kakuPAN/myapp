class CommentsController < ApplicationController
  before_action :authenticate, except: %i[ index ]
  before_action :set_board

  def index
    @comments = @board.comments.where(parent_id: nil).includes(:children).order(created_at: :desc)
    @comment = Comment.new
  end

  def create
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
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:danger] = "コメントが存在しません"
      redirect_to board_comments_path(@board)
    end
  end

  def update
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:danger] = "コメントが存在しません"
      redirect_to board_comments_path(@board)
    end
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
    @comment = Comment.find_by(id: params[:id])
    unless @comment
      flash[:danger] = "コメントが存在しません"
      redirect_to board_comments_path(@board)
    end
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
    @parent = Comment.find_by(id: params[:parent_id])
    unless @parent
      flash[:danger] = "コメントが存在しません"
      redirect_to board_comments_path(@board)
    end
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

  def set_board
    @board = Board.find_by(id: params[:board_id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
    end
  end


  def comment_params
    params.require(:comment).permit(:body, :parent_id)
  end

  def reply_params
    params.require(:reply).permit(:body)
  end
end
