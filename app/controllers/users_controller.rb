class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update show show_profile all_users_boards bookmarked_boards ]
  before_action :set_search

  def new
    if current_user
      redirect_to boards_path
      flash[:danger] = "すでにログインしています"
    end
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path
      flash[:primary] = "#{@user.user_name}さまを登録しました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @most_popular_boards = Board.where(user_id: @user).limit(4) # 後で最もリアクションのついた投稿を取得する
    @most_commented_board = Board.where(user_id: @user).limit(4) # 後で最もコメントのついた投稿を取得する
  end

  def all_users_boards
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :users
    if current_user == @user
      @board_scope = Board.where(user_id: @user)
    else
      @board_scope = Board.where("access_level = ? AND user_id = ?", 1, @user)
    end
    @boards = @board_scope.order(created_at: :desc).page(@page).per(4)
    render :show
  end

  def bookmarked_boards # ブックマークした投稿
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :bookmarked
    if current_user == @user
      @board_scope = Board.where(user_id: @user)
    else
      @board_scope = Board.where("access_level = ? AND user_id = ?", 1, @user)
    end
    @boards = @board_scope.order(created_at: :desc).page(@page).per(4)
    render :show
  end

  def show_profile
    unless current_user == @user
      redirect_to user_path(@user)
      flash[:danger] = "権限がありません"
      return
    end
    render :show_profile
  end

  def edit
    unless current_user == @user
      redirect_to user_path(@user)
      flash[:danger] = "権限がありません"
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザープロフィールを変更しました"
      redirect_to show_profile_user_path(@user)
    else
      render :edit, status: :unprocessable_entity
      flash[:danger] = "変更を保存できません"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile, :email, :password, :password_confirmation, :avatar_image)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_search
    @index_page = params[:page].to_i # 不正なページ番号を補正（0以下の値や文字列を1にする）
    @index_page = 1 if @index_page < 1
    if current_user
      @q = Board.where("access_level = ? OR user_id = ?", 1, current_user.id).ransack(params[:q])
    else
      @q = Board.where(access_level: 1).ransack(params[:q])
    end
    @index_boards = @q.result(distinct: true).includes(:user).order(created_at: :desc).page(@index_page).per(2)
  end
end
