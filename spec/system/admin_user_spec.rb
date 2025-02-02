require 'rails_helper'

RSpec.describe "AdminUsers", type: :system do
  let!(:security_question) { create(:security_question, question_text: "秘密の質問") }
  let!(:general_user) { create(:user, security_question_id: security_question.id) }
  let!(:admin_user) { create(:user, user_name: "admin_user", role: 1, security_question_id: security_question.id) }

  describe "一般ユーザーによるアクセス" do
    describe "管理者ページへのアクセスが失敗する" do
      before { login(general_user) }
      it "ユーザー一覧ページへのアクセスが失敗する" do
        visit admin_users_path
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
      it "ユーザー詳細ページへのアクセスが失敗する" do
        visit admin_user_path(general_user)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
      it "ユーザー作成ページへのアクセスが失敗する" do
        visit new_admin_user_path
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
    end
  end

  describe "管理者ユーザーによるアクセス" do
    before do
      admin_user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')),
      filename: 'sample_image.png',
      content_type: 'image/png')
      admin_user.save!
    end
    before { login(admin_user) }
    describe "ユーザー一覧ページにアクセス" do
      it "ユーザー一覧にユーザーの情報が表示される" do
        visit admin_users_path
        expect(page).to have_content(general_user.user_name)
        expect(page).to have_content(admin_user.user_name)
        expect(current_path).to eq admin_users_path
      end
    end
    describe "ユーザー詳細ページにアクセス" do
      it "ユーザー詳細にユーザーの詳細情報が表示される" do
        visit admin_users_path
        find("#user-link-#{admin_user.id}").click
        expect(page).to have_content(I18n.t("enums.user.role.#{admin_user.role}"))
        expect(page).to have_content(admin_user.id)
        expect(page).to have_content(admin_user.user_name)
        expect(page).to have_content(admin_user.email)
        expect(page).to have_content(admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S'))
        expect(page).to have_selector("img[src*='sample_image.png']")
      end
    end
    describe "管理者ユーザー作成ページにアクセス" do
      context "入力が正常な場合" do
        it "管理者を作成できる" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          select admin_user.security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"
          click_button "登録"

          expect(page).to have_content("管理者ユーザーを作成しました", wait: 5)
          new_user = User.find_by(email: "new_user@email.com")
          expect(page).to have_content(new_user.user_name)
          expect(current_path).to eq admin_user_path(new_user)
        end
      end
      context "ユーザーネームが未入力の場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: ""
          fill_in "user_email", with: "new_user@email.com"
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("ユーザーネームを入力してください")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "メールアドレスが未入力の場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: ""
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("メールアドレスを入力してください")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "メールアドレスがすでに登録済みの場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: general_user.email
          fill_in "user_password", with: "password"
          fill_in "user_password_confirmation", with: "password"
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("メールアドレスはすでに存在します")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "パスワードが未入力の場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          fill_in "user_password", with: ""
          fill_in "user_password_confirmation", with: ""
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("パスワードは3文字以上で入力してください")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "パスワード確認が未入力の場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          password = Faker::Lorem.paragraph_by_chars(number: 3)
          fill_in "user_password", with: password
          fill_in "user_password_confirmation", with: ""
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("パスワード確認を入力してください")
          expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "パスワードが3文字未満の場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          password = "p"
          fill_in "user_password", with: password
          fill_in "user_password_confirmation", with: password
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"

          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("パスワードは3文字以上で入力してください")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "パスワードとパスワード確認が一致しない場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          password = Faker::Lorem.paragraph_by_chars(number: 3)
          fill_in "user_password", with: password
          fill_in "user_password_confirmation", with: "misspassword"
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: "回答"
          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

          expect(current_path).to eq new_admin_user_path
        end
      end

      context "秘密の質問の回答を入力していない場合" do
        it "ユーザーの作成が失敗する" do
          visit admin_users_path
          page.driver.browser.manage.window.resize_to(1024, 768) # 大サイズ
          find('#header-user-name', visible: true, wait: 10).hover # ホバーは名前(実際に表示中の要素)にする必要がある
          expect(page).to have_selector('#header-create-admin', visible: true, wait: 5)
          find("#header-create-admin").click

          fill_in "user_user_name", with: "new_user"
          fill_in "user_email", with: "new_user@email.com"
          password = Faker::Lorem.paragraph_by_chars(number: 3)
          fill_in "user_password", with: password
          fill_in "user_password_confirmation", with: "misspassword"
          select security_question.question_text, from: "user_security_question_id"
          fill_in "user_security_answer", with: ""
          click_button "登録"

          expect(page).to have_content("入力に不足があります")
          expect(page).to have_content("秘密の質問の答えを入力してください")

          expect(current_path).to eq new_admin_user_path
        end
      end
    end

    describe "ユーザー削除" do
      context "一般ユーザーを削除する場合" do
        it "ユーザーの削除が成功する" do
          visit admin_user_path(general_user)

          find("#delete-user-button").click
          expect(page).to have_content("ユーザーを削除しました")
          expect(current_path).to eq admin_users_path

          expect(User.exists?(id: general_user.id)).to be_falsey # ユーザーが存在しないことを確認
        end
      end
      context "管理者ユーザーを削除する場合" do
        context "管理者ユーザーの数が２つ以上の場合" do # 管理者が１つの場合は自分自身を削除と同様
          let!(:admin_user_sub) { create(:user, user_name: "sub_admin_user", role: 1, security_question_id: security_question.id) }
          context "ユーザーが別の管理者を削除する場合" do
            it "ユーザーの削除が成功する" do
              visit admin_user_path(admin_user_sub)

              find("#delete-user-button").click
              expect(page).to have_content("ユーザーを削除しました")
              expect(current_path).to eq admin_users_path

              expect(User.exists?(id: admin_user_sub.id)).to be_falsey # ユーザーが存在しないことを確認
            end
          end
          context "管理者が自分自身を削除する場合" do
            it "ユーザーの削除に失敗する" do
              visit admin_user_path(admin_user)
              find("#delete-user-button").click
              expect(page).to have_content("このユーザーは削除できません")
              expect(current_path).to eq admin_user_path(admin_user)
              expect(User.exists?(id: admin_user.id)).to be_truthy
            end
          end
        end
      end
    end
  end
end
