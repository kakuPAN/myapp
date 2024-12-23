require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let(:user) { create(:user) }

  describe "ログイン" do
    context "認証情報が正しい場合" do
      it "ログインが成功する" do
        visit root_path
        click_link "ログイン"
        fill_in "session-email", with: user.email
        fill_in "session-password", with: "password"
        click_button "ログイン"

        expect(page).to have_content("#{user.user_name}さまがログインしました")
        expect(current_path).to eq tasks_path
      end
    end

    context "メールアドレスに誤りがある場合" do
      it "ログインに失敗する" do
        visit root_path
        click_link "ログイン"
        fill_in "session-email", with: "miss@email.com"
        fill_in "session-password", with: "password"
        click_button "ログイン"

        expect(page).to have_content("ユーザーが存在しません")
        expect(current_path).to eq login_path
      end
    end

    context "パスワードに誤りがある場合" do
      it "ログインに失敗する" do
        visit root_path
        click_link "ログイン"
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
      click_link "ログアウト"

      expect(page).to have_content("ログアウトしました")
      expect(current_path).to eq root_path
    end
  end
end
