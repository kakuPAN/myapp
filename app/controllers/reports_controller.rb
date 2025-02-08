class ReportsController < ApplicationController
  before_action :authenticate
  before_action :set_board, only: %i[ new_board_report create_board_report ]
  before_action :set_comment, only: %i[ new_comment_report create_comment_report ]

  def new_board_report
    @report = Report.new
  end

  def create_board_report
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
    @board = @comment.board
    @report = Report.new
  end

  def create_comment_report
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

  def set_board
    @board = Board.find_by(id: params[:board_id])
    unless @board
      flash[:danger] = "トピックが存在しません"
      redirect_to boards_path
    end
  end

  def set_comment
    @comment = Comment.find_by(id: params[:comment_id])
    unless @comment
      flash[:danger] = "コメントが存在しません"
      redirect_to board_comments_path(@board)
    end
  end

  def report_params
    params.require(:report).permit(:body, :board_id, :comment_id)
  end
end
