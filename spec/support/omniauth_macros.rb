module OmniAuthMacros
  def mock_google_oauth2(user)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: user.uid || Faker::Internet.uuid,
      info: {
        name: user.user_name,
        email: user.email
      }
    )
  end
  def mock_auth_hash(email: "test@example.com", provider: "google_oauth2", uid: "123456")
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: provider,
      uid: uid,
      info: {
        name: "Test User",
        email: email
      }
    )
  end
end
