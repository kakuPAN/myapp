class UsersController < ApplicationController
  def new
    if current_user
      redirect_to goals_path
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

  private

  def user_params
    params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
  end
end
