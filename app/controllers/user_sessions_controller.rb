class UserSessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_to home_pages_path, notice: "#{@user.user_name}さまがログインしました"
    else
      flash.now[:notice] = "ユーザーが存在しません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
  end
end
