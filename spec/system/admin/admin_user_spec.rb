require 'rails_helper'

RSpec.describe "AdminUsers", type: :system do
  let!(:general_user) { create(:user, :with_google) }
  let!(:admin_user) { create(:user, :with_google, :admin) }
  describe "ログインしていないユーザーによるアクセス" do
    describe "管理者ページへのアクセスが失敗する" do
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
        visit admin_user_path(admin_user)
        expect(page).to have_current_path(admin_user_path(admin_user.id), wait: 5)
        expect(page).to have_content(I18n.t("enums.user.role.#{admin_user.role}"))
        expect(page).to have_content(admin_user.id)
        expect(page).to have_content(admin_user.user_name)
        expect(page).to have_content(admin_user.email)
        expect(page).to have_content(admin_user.created_at.strftime('%Y-%m-%d %H:%M:%S'))
        expect(page).to have_selector("img[src*='sample_image.png']")
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
          let!(:admin_user_sub) { create(:user, :with_google, :admin) }
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
              expect(page).to have_content("ユーザーを削除できません")
              expect(current_path).to eq admin_user_path(admin_user)
              expect(User.exists?(id: admin_user.id)).to be_truthy
            end
          end
        end
      end
    end
  end
end
