module OmniauthMacros
  def mock_google_auth(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid: Faker::Number.number(digits: 10).to_s,
      info: {
        email: user.email,
        name: user.user_name
      }
    )
  end
end
