class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update show show_profile liked_boards visited_boards user_actions ]

  def new
    if current_user
      redirect_to boards_path
      flash[:danger] = "すでにログインしています"
    end
    @user = User.new
    @security_questions = SecurityQuestion.all
  end

  def create
    @user = User.new(user_params)

    if params[:user][:security_answer].present?
      @user.encrypt_security_answer(params[:user][:security_answer])
    end
    if @user.save
      auto_login(@user)
      redirect_to user_path(@user)
      flash[:primary] = "#{@user.user_name}さまがログインしました"
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @boards = Kaminari.paginate_array(Board.all.sample(10)).page(@page).per(4)
  end

  def destroy
    @user =  User.find(params[:id])
    if @user == current_user
      @user.destroy
      redirect_to root_path
    else
      redirect_to user_path(@user)
      flash[:success] = "権限がありません"
    end
  end

  def liked_boards # お気に入り
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :liked
    @boards = Kaminari.paginate_array(@user.likes.includes(:board).order(created_at: :desc).map(&:board)).page(@page).per(4)
    render :show
  end

  def visited_boards # 閲覧履歴
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :visited
    @boards = Kaminari.paginate_array(user_board_history(@user)).page(@page).per(4)
    render :show
  end

  def user_actions # ユーザーの活動
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :user_action
    @logs_with_boards = 
      @user.board_logs.where("action_type != ?", 0)
      .includes(:board, :frame)
      .order(created_at: :desc)
      .map do |log|
        { board: log.board, frame: log.frame, action_date: log.created_at, action_type: log.action_type }
      end
    @boards = Kaminari.paginate_array(@logs_with_boards).page(@page).per(4)
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
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to user_path(@user)
          flash[:success] = "プロフィールを変更しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "プロフィールを変更できません"
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile, :email, :password, :password_confirmation, :avatar_image, :security_question_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_board_history(user)
    filtered_boards = []

    all_visited_boards = user.user_boards.where(created_at: (Time.current - 1.week)..Time.current).order(created_at: :desc)
    all_visited_boards.each do |visited_board|
      unless filtered_boards.any? { |board| board.id == visited_board.board_id }
        board = Board.find(visited_board.board_id) 
        filtered_boards << board
      end
    end
    filtered_boards
  end
end
