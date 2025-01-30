class Admin::UsersController < Admin::BaseController
  skip_before_action :set_search
  before_action :set_search_user
  before_action :set_user, only: %i[show destroy]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if params[:user][:security_answer].present?
      @user.encrypt_security_answer(params[:user][:security_answer])
    end
    @user.role = 1
    if @user.save
      flash[:success] = "管理者ユーザーを作成しました"
      redirect_to admin_user_path(@user)
    else
      flash.now[:danger] = "入力に不足があります"
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    if @user.admin? && (User.admin.count == 1 || @user == current_user)
      flash[:danger] = "このユーザーは削除できません"
      redirect_to admin_user_path(@user)
      return
    end
    if @user.destroy
      flash[:success] = "ユーザーを削除しました"
      redirect_to admin_users_path
    else
      flash[:danger] = "ユーザーを削除できません"
      redirect_to admin_user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :profile, :email, :password, :password_confirmation, :avatar_image, :security_question_id)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      flash[:danger] = "ユーザーが存在しません"
      redirect_to admin_users_path
    end
  end

  def set_search_user
    @index_page = params[:page].to_i
    @index_page = 1 if @index_page < 1
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).order(created_at: :desc).page(@index_page).per(10)
    @all_users = User.all
  end
end