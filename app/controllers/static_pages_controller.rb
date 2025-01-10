class StaticPagesController < ApplicationController
  before_action :set_search
  def top
    @boards = Board.all.limit(100)
  end

  private

  def set_search
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = Board.ransack(params[:q])
    @index_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(@index_page).per(50)
  end
end
