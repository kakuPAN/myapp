class UserSessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to tasks_path
      flash[:primary] = "#{@user.user_name}さまがログインしました"
    else
      flash.now[:danger] = "ユーザーが存在しません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
    flash[:primary] = "ログアウトしました"
  end
end
