module LoginMacros
  def login(user)
    visit login_path
    fill_in "session-email", with: user.email
    fill_in "session-password", with: "password"
    find('#login-submit').click
    if user.admin?
      expect(page).to have_content("管理者：#{user.user_name}がログインしました")
      expect(current_path).to eq admin_users_path
    else
      expect(page).to have_content("#{user.user_name}さまがログインしました")
      expect(current_path).to eq user_path(user)
    end
  end
end
