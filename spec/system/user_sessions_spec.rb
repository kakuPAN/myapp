require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:security_question) { create(:security_question) }
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, user_name: "admin_user", role: 1, security_question_id: security_question.id) }

  describe "ログイン" do
    context "認証情報が正しい場合" do
      context "一般ユーザーの場合" do
        it "ログイン後、ユーザーマイページに遷移" do
          visit login_path
          fill_in "session-email", with: user.email
          fill_in "session-password", with: "password"
          find('#login-submit').click
          expect(page).to have_content("#{user.user_name}さまがログインしました")
          expect(current_path).to eq user_path(user)
        end
      end
      context "管理者ユーザーの場合" do
        it "ログイン後、管理者ページに遷移" do
          visit login_path
          fill_in "session-email", with: admin_user.email
          fill_in "session-password", with: "password"
          find('#login-submit').click
          expect(page).to have_content("管理者：#{admin_user.user_name}がログインしました")
          expect(current_path).to eq admin_users_path
        end
      end
    end

    context "メールアドレスに誤りがある場合" do
      it "ログインに失敗する" do
        visit login_path
        fill_in "session-email", with: "miss@email.com"
        fill_in "session-password", with: "password"
        click_button "ログイン"

        expect(page).to have_content("ユーザーが存在しません")
        expect(current_path).to eq login_path
      end
    end

    context "パスワードに誤りがある場合" do
      it "ログインに失敗する" do
        visit login_path
        fill_in "session-email", with: user.email
        fill_in "session-password", with: "misspassword"
        click_button "ログイン"

        expect(page).to have_content("ユーザーが存在しません")
        expect(current_path).to eq login_path
      end
    end
  end

  describe "ログアウト" do
    before { login(user) }
    it "ログアウト後、トップ画面にリダイレクトされる" do
      page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
      find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
      expect(page).to have_selector('#header-logout', visible: true, wait: 5)

      find('#header-logout').click

      expect(page).to have_content("ログアウトしました")
      expect(current_path).to eq root_path
    end
  end
end
