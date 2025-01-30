class Admin::ReportsController < Admin::BaseController
  before_action :set_board
  before_action :set_report_and_board, only: %i[show destroy]
  def index
    @reports = Report.where(board_id: @board.id).order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
  end

  def destroy
    if @report.destroy
      flash[:success] = "報告を削除しました"
      redirect_to admin_reports_path(board_id: @board.id)
    else
      flash[:danger] = "報告を削除できません"
      redirect_to admin_report_path(@report)
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

  def set_report_and_board
    @report = Report.find_by(id: params[:id])
    unless @report
      flash[:danger] = "報告が存在しません"
      redirect_to admin_reports_path(board_id: @board.id)
    end
  end
end
