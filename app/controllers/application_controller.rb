class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def not_authenticated
    redirect_to login_path
    flash[:danger] = 'ログインしてください'
  end
end
