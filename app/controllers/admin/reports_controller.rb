class Admin::ReportsController < Admin::BaseController
  before_action :set_board
  def index
    @reports = Report.where(board_id: @board.id).order(created_at: :desc).page(params[:page]).per(2)
  end
  
  private
    def set_board
      @board = Board.find(params[:board_id])
    end
end