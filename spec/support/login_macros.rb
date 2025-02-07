module LoginMacros
  def login(user)
    visit root_path
    click_link "Sign in with Google"
    expect(page).to have_content("#{user.user_name}さまがログインしました")

    if user.admin?
      expect(current_path).to eq admin_users_path
    else
      expect(current_path).to eq visited_boards_user_path(user)
    end
  end
end
