require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user, :with_google) }
  before do
    page.driver.browser.manage.window.resize_to(1400, 900)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '123456',
      info: { name: 'Test User', email: 'test@example.com' }
    )
  end
  describe "ログインボタンをクリック" do
    context "ユーザーが存在しない場合" do
      it "新しくユーザーを作成してログイン" do
        visit root_path
        find("#google-login-button").click
        user = User.find_by(email: 'test@example.com')
        expect(user).not_to be_nil
        expect(page).to have_current_path(visited_boards_user_path(user))
      end
    end
    context "ユーザーが存在する場合" do
      context "一般ユーザーの場合ログイン" do
        let!(:existing_user) { create(:user, provider: "google_oauth2", uid: "123456", email: "test@example.com") }
        it "ログイン後、マイページに遷移" do
          visit root_path
          find("#google-login-button").click
          expect(page).to have_current_path(visited_boards_user_path(existing_user))
        end
      end
      context "管理者の場合" do
        let!(:admin_user) { create(:user, provider: "google_oauth2", uid: "123456", email: "test@example.com", role: 1) }
        it "ログイン後、管理者ページに遷移" do
          visit root_path
          find("#google-login-button").click
          expect(page).to have_current_path(admin_users_path)
        end
      end
    end
  end
  describe "ログアウト" do
    before do
      page.driver.browser.manage.window.resize_to(1400, 900)
      login(user)
      visit visited_boards_user_path(user)
    end
    it "ログアウト後、トップ画面にリダイレクトされる" do
      find('#header-user-name', visible: true, wait: 5).hover
      expect(page).to have_selector('#header-logout', visible: true, wait: 5)
      find('#header-logout').click
      expect(page).to have_selector("#google-login-button", visible: true, wait: 5)
      expect(page).to have_content("ログアウトしました")
      expect(current_path).to eq root_path
    end
  end
end
