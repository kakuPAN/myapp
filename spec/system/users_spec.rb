require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }
  let!(:registered_user) { create(:user, email: "registered@email.com") }
  describe "ユーザー作成" do
    context "ログイン前" do
      it "フォームの入力値が正常な場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "登録"

        expect(page).to have_content("new_userさまを登録しました")

        expect(current_path).to eq login_path
      end
      
      it "ユーザーネームが未入力の場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: ""
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("ユーザーネームを入力してください")

        expect(current_path).to eq new_user_path
      end

      it "メールアドレスが未入力の場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: ""
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("メールアドレスを入力してください")

        expect(current_path).to eq new_user_path
      end

      it "メールアドレスがすでに登録済みの場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: registered_user.email
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: "password"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("メールアドレスはすでに存在します")

        expect(current_path).to eq new_user_path
      end

      it "パスワードが未入力の場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: ""
        fill_in "user_password_confirmation", with: "password"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("パスワードは3文字以上で入力してください")
        expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

        expect(current_path).to eq new_user_path
      end

      it "パスワード確認が未入力の場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "password"
        fill_in "user_password_confirmation", with: ""
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")
        expect(page).to have_content("パスワード確認を入力してください")

        expect(current_path).to eq new_user_path
      end

      it "パスワードが3文字未満の場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "pa"
        fill_in "user_password_confirmation", with: "pa"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("パスワードは3文字以上で入力してください")

        expect(current_path).to eq new_user_path
      end

      it "パスワードとパスワード確認が一致しない場合" do
        visit root_path
        click_link "ユーザー作成"

        fill_in "user_user_name", with: "new_user"
        fill_in "user_email", with: "new_user@email.com"
        fill_in "user_password", with: "pass"
        fill_in "user_password_confirmation", with: "nopass"
        click_button "登録"

        expect(page).to have_content("入力に不足があります")
        expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

        expect(current_path).to eq new_user_path
      end
    end
  end

  describe "ログイン後にユーザー作成画面にアクセスする場合" do
    before { login(user) }
    it "タスク一覧にリダイレクトする" do
      visit new_user_path

      expect(page).to have_content("すでにログインしています")
      expect(current_path).to eq tasks_path
    end
  end
end
