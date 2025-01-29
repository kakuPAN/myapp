class ReportsController < ApplicationController

  def new_board_report
    @board = Board.find(params[:board_id])
    @report = Report.new
  end

  def create_board_report
    @board = Board.find(params[:board_id])
    @report = Report.new(report_params)
    @report.user = current_user
    if @report.save
      redirect_to board_path(@report.board)
      flash[:success] = "報告しました"
    else
      flash.now[:success] = "報告を作成できません"
      render :new_board_report, status: :unprocessable_entity
    end
  end

  def new_comment_report
    @comment = Comment.find(params[:comment_id])
    @board = @comment.board
    @report = Report.new
  end

  def create_comment_report
    @comment = Comment.find(params[:comment_id])
    @board = @comment.board
    @report = Report.new(report_params)
    @report.user = current_user
    if @report.save
      redirect_to board_comments_path(@board)
      flash[:success] = "報告しました"
    else
      flash.now[:success] = "報告を作成できません"
      render :new_comment_report, status: :unprocessable_entity
    end
  end

  private

  def report_params
    params.require(:report).permit(:body, :board_id, :comment_id)
  end

end
