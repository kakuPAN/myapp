class UsersController < ApplicationController
  before_action :set_user

  def liked_boards # お気に入り
    if @user.admin? && !current_user&.admin?
      flash[:danger] = "ユーザーが存在しません"
      redirect_to boards_path
      return
    end
    @visited_boards_count = user_board_history(@user).count
    @logs_with_boards = logs_with_boards(@user)
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :liked
    @boards = Kaminari.paginate_array(@user.likes.includes(:board).order(created_at: :desc).map(&:board)).page(@page).per(4)
    render :show
  end

  def visited_boards # 閲覧履歴
    unless @user == current_user
      redirect_to liked_boards_user_path(@user)
      flash[:danger] = "権限がありません"
      return
    end
    @visited_boards_count = user_board_history(@user).count
    @logs_with_boards = logs_with_boards(@user)
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :visited
    @boards = Kaminari.paginate_array(user_board_history(@user)).page(@page).per(4)
    render :show
  end

  def user_actions # ユーザーの活動
    if @user.admin? && !current_user&.admin?
      flash[:success] = "ユーザーが存在しません"
      redirect_to boards_path
      return
    end
    @visited_boards_count = user_board_history(@user).count
    @page = params[:page].to_i
    @page = 1 if @page < 1
    @context = :user_action
    @logs_with_boards = logs_with_boards(@user)
    @boards = Kaminari.paginate_array(@logs_with_boards).page(@page).per(4)
    render :show
  end

  def show_profile
    if @user && @user == current_user
      render :show_profile
    else
      redirect_to liked_boards_user_path(@user)
      flash[:success] = "権限がありません"
    end
  end

  def edit
    unless current_user == @user
      redirect_to liked_boards_user_path(@user)
      flash[:success] = "権限がありません"
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html do
          redirect_to visited_boards_user_path(@user)
          flash[:success] = "プロフィールを編集しました"
        end
      else
        format.turbo_stream do
          flash.now[:success] = "プロフィールを編集できません"
        end
      end
    end
  end

  def destroy
    if @user.admin?
      redirect_to admin_users_path
      flash[:danger] = "この操作はできません"
      return
    end
    if @user == current_user
      @user.destroy
      redirect_to root_path
      flash[:success] = "退会が完了しました"
    else
      redirect_to liked_boards_user_path(@user)
      flash[:danger] = "権限がありません"
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile, :email, :password, :password_confirmation, :avatar_image)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      redirect_to root_path
      flash[:danger] = "ユーザーが存在しません"
    end
  end

  def user_board_history(user)
    filtered_boards = []

    all_visited_boards = user.user_boards.order(created_at: :desc)
    all_visited_boards.each do |visited_board|
      unless filtered_boards.any? { |board| board.id == visited_board.board_id }
        board = Board.find(visited_board.board_id)
        filtered_boards << board
      end
    end
    filtered_boards
  end

  def logs_with_boards(user)
    logs_with_boards =
    user.board_logs.where("action_type != ?", 0)
    .includes(:board, :frame)
    .order(created_at: :desc)
    .map do |log|
      { board: log.board, frame: log.frame, action_date: log.created_at, action_type: log.action_type }
    end
    logs_with_boards
  end
end
