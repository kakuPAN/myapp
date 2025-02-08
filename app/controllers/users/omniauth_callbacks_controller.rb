class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    callback_for(:google)
  end

  def callback_for(provider)
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in @user
      if @user.admin?
        redirect_to admin_users_path
        flash[:success] = "管理者としてログインしました"
      else
        redirect_to visited_boards_user_path(@user)
        set_flash_message(:notice, :success, kind: provider.to_s.capitalize) if is_navigational_format?
      end
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth'].except(:extra)
      redirect_to root_path
    end
  end
end