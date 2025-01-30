class ApplicationController < ActionController::Base
  
  allow_browser versions: :modern
  helper_method :breadcrumbs
  before_action :set_search

  def not_authenticated
    redirect_to login_path
    flash[:danger] = "ログインしてください"
  end

  def breadcrumbs
    @breadcrumbs ||= []
  end

  def add_breadcrumb(name, path = nil)
    breadcrumbs << Breadcrumb.new(name, path)
  end

  def set_search
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = Board.ransack(params[:q])
    @index_boards = @q.result(distinct: true).order(created_at: :desc).page(@index_page).per(10)
    @all_boards = Board.all
  end

  def routing_error
    redirect_to root_path, alert: "ページが見つかりませんでした"
  end

  private

end
