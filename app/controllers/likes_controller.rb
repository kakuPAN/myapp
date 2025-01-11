class LikesController < ApplicationController
  before_action :require_login
  before_action :set_board

  private
  def set_board
    @board = Board.find(params[:board_id])
  end
end
