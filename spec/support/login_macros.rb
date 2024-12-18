module LoginMacros
  def login(user)
    visit login_path
    fill_in 'session-email', with: user.email
    fill_in 'session-password', with: 'complex-password-complex'
    click_on 'ログイン'
  end
end
