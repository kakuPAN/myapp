class BoardsController < ApplicationController
  def index
    @all_boards = Board.all
    @boards= Board.order(created_at: :desc).page(params[:page]).per(2)
  end

  def show
    @board = Board.find(params[:id])
  end

end
