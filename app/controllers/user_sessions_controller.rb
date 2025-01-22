class UserSessionsController < ApplicationController

  def new
  end

  def create
    unless current_user
      @user = login(params[:email], params[:password])
      if @user
        redirect_to user_path(@user)
        flash[:success] = "#{@user.user_name}さまがログインしました"
      else
        flash.now[:success] = "ユーザーが存在しません"
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to user_path(@user)
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
    flash[:success] = "ログアウトしました"
  end
end
