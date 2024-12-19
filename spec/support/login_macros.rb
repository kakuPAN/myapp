module LoginMacros
  def login(user)
    visit login_path
    fill_in 'session-email', with: user.email
    fill_in 'session-password', with: 'password'
    click_on 'ログイン'

    expect(page).to have_current_path(tasks_path)
  end
end
