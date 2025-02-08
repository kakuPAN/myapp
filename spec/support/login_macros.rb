module LoginMacros
  def login(user)
    mock_google_oauth2(user)
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]  # Deviseの設定
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]  # モック認証データを設定
    sign_in user
  end
end
