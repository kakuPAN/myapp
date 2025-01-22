module LoginMacros
  def login(user)
    visit login_path
    fill_in "session-email", with: user.email
    fill_in "session-password", with: "password"
    find('#login-submit').click
    expect(page).to have_content("#{user.user_name}さまがログインしました")
    expect(current_path).to eq user_path(user)
  end
end
