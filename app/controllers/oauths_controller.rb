class OauthsController < ApplicationController
  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if (@user = login_from(provider))
      redirect_to visited_boards_user_path(@user), notice:"#{provider.titleize}アカウントでログインしました"
    else
      begin
        signup_and_login(provider)
        redirect_to visited_boards_user_path(@user), notice:"#{provider.titleize}アカウントでログインしました"
      rescue
        redirect_to root_path, alert:"#{provider.titleize}アカウントでのログインに失敗しました"
      end
    end
  end

  private

  def auth_params
    params.permit(:provider)
  end

  def signup_and_login(provider)
    @user = create_from(provider)
    if @user.email == Rails.application.credentials.dig(:admin, :email)
      @user.update(role: 1)
    end
    reset_session
    auto_login(@user)
  end
end
