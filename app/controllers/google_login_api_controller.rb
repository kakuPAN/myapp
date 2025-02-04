class GoogleLoginApiController < ApplicationController
  require 'googleauth/id_tokens/verifier'

  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token

  def callback
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: Rails.application.credentials.dig(:google_api, :client_id))
    user = User.find(email: payload['email'])
    unless user
      user = User.new
      user.email = payload["email"]
      user.user_name = payload["name"]
      user.save!
    end
    session[:user_id] = user.id
    redirect_to after_login_path
    flash[:success] = 'ログインしました'
  end

  private

  def verify_g_csrf_token
    if cookies["g_csrf_token"].blank? || params[:g_csrf_token].blank? || cookies["g_csrf_token"] != params[:g_csrf_token]
      redirect_to root_path, notice: '不正なアクセスです'
    end
  end
end
