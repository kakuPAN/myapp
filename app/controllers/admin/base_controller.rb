class Admin::BaseController < ApplicationController
  before_action :check_admin
  before_action :set_search
  layout "admin/layouts/application"

  private

  def not_authenticated
    flash[:warning] = "権限がありません"
    redirect_to login_path
  end

  def check_admin
    unless current_user&.admin?
      flash[:danger] = "権限がありません"
      redirect_to root_path
    end
  end

  def set_search
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = Board.ransack(params[:q])
    @boards = @q.result(distinct: true).order(created_at: :desc).page(@index_page).per(10)
    @all_boards = Board.all
  end
end
