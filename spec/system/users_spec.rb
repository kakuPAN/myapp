require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user, :with_google) }
  let!(:other_user) { create(:user, :with_google) }
  # ユーザー作成についてはOauthsControllerのテストによって替える

  describe "ユーザーマイページ" do
    let!(:board) { create(:board) }
    describe "自分以外のユーザーのマイページにアクセス" do
      let!(:other_user_board_log) { create(:board_log, user_id: other_user.id, board_id: board.id, action_type: 1) }
      let!(:other_user_like) { create(:like, user_id: other_user.id, board_id: board.id) }
      let!(:other_user_visiter_board) { create(:user_board, user_id: other_user.id, board_id: board.id) }

      it "ユーザーのマイページにアクセスできる" do
        visit liked_boards_user_path(other_user)
        expect(current_path).to eq liked_boards_user_path(other_user)
      end
      describe "ユーザープロフィールの編集" do
        it "ユーザーのプロフィール編集リンクが表示されない" do
          visit liked_boards_user_path(other_user)
          expect(page).not_to have_selector("#users-setting")
        end
        it "ユーザーのプロフィール編集ページにアクセスできない" do
          visit edit_user_path(other_user)
          expect(page).to have_content "権限がありません"
          expect(current_path).to eq liked_boards_user_path(other_user)
        end
      end
      it "ユーザーのユーザー情報にアクセスできない" do
        visit show_profile_user_path(other_user)
        expect(page).to have_content "権限がありません"
        expect(current_path).to eq liked_boards_user_path(other_user)
      end
      describe "ユーザーのお気に入り一覧ページにアクセス" do
        it "ユーザーがお気に入りに登録したトピックが表示される" do
          visit liked_boards_user_path(other_user)
          expect(page).to have_content other_user.liked_boards.last.title
          expect(page).to have_current_path(liked_boards_user_path(other_user), wait: 5)
        end
      end
      describe "ユーザーの活動一覧ページにアクセス" do
        it "ユーザーの活動に関連するトピックが表示される" do
          visit liked_boards_user_path(other_user)
          click_link "ユーザーの活動"
          expect(page).to have_content other_user.user_board_actions.last.title
          expect(page).to have_current_path(user_actions_user_path(other_user), wait: 5)
        end
      end
      describe "ユーザーの閲覧履歴にアクセス" do
        it "閲覧履歴へのリンクが表示されない" do
          visit liked_boards_user_path(other_user)
          expect(page).not_to have_content "閲覧履歴"
          expect(current_path).to eq liked_boards_user_path(other_user)
        end
        it "閲覧履歴にアクセスできない" do
          visit visited_boards_user_path(other_user)
          expect(page).not_to have_content("権限がありません", wait: 5)
          expect(current_path).to eq liked_boards_user_path(other_user)
        end
      end
    end
    describe "自分のマイページにアクセス" do
      let!(:user_board_log) { create(:board_log, user_id: user.id, board_id: board.id, action_type: 1) }
      let!(:user_like) { create(:like, user_id: user.id, board_id: board.id) }
      let!(:user_visiter_board) { create(:user_board, user_id: user.id, board_id: board.id) }
      before { login(user) }

      it "ユーザーのマイページにアクセスできる" do
        visit visited_boards_user_path(user)
        expect(current_path).to eq visited_boards_user_path(user)
      end
      describe "ユーザープロフィールの編集" do
        context "入力内容が正常な場合" do
          it "プロフィールが編集できる" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
            fill_in "user-name", with: "編集したユーザー名"
            fill_in "user_profile", with: "編集したプロフィール"
            find("#submit-button").click
            expect(page).to have_content "プロフィールを編集しました"
            expect(page).to have_content("編集したユーザー名")
            expect(page).to have_content("編集したプロフィール")
            expect(page).to have_selector("img[src*='sample_image.png']")
            expect(current_path).to eq visited_boards_user_path(user)
          end
        end
        context "200KBを超えるファイルをアップロードした場合" do
          it "プロフィールの編集が失敗する" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/over_size.png"))
            fill_in "user-name", with: "編集したユーザー名"
            fill_in "user_profile", with: "編集したプロフィール"
            find("#submit-button").click
            expect(page).to have_content "プロフィールを編集できません"
            expect(page).to have_content "200KB以下のファイルをアップロードしてください"
            expect(current_path).to eq edit_user_path(user)
          end
        end
        context "ファイル形式が、JPEG, JPG, PNG以外の場合" do
          it "プロフィールの編集が失敗する" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/webp_test.webp"))
            fill_in "user-name", with: "編集したユーザー名"
            fill_in "user_profile", with: "編集したプロフィール"
            find("#submit-button").click
            expect(page).to have_content "プロフィールを編集できません"
            expect(page).to have_content "ファイル形式が、JPEG, JPG, PNG以外になっています"
            expect(current_path).to eq edit_user_path(user)
          end
        end
        context "ユーザー名が空の場合" do
          it "プロフィールの編集が失敗する" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
            fill_in "user-name", with: ""
            fill_in "user_profile", with: "編集したプロフィール"
            expect(find("#submit-button")[:disabled]).to eq "true" # 空の場合、作成ボタンを押下できない
            expect(current_path).to eq edit_user_path(user)
          end
        end
        context "ユーザー名の入力が20文字を超える場合" do
          it "プロフィールの編集が失敗する" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
            fill_in "user-name", with: Faker::Lorem.paragraph_by_chars(number: 21)
            fill_in "user_profile", with: "編集したプロフィール"
            find("#submit-button").click
            expect(page).to have_content "プロフィールを編集できません"
            expect(page).to have_content "ユーザーネームは20文字以内で入力してください"
            expect(current_path).to eq edit_user_path(user)
          end
        end
        context "プロフィールの入力が250文字を超える場合" do
          it "プロフィールの編集が失敗する" do
            visit visited_boards_user_path(user)
            find("#users-setting").click
            attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
            fill_in "user-name", with: "編集したユーザー名"
            fill_in "user_profile", with: Faker::Lorem.paragraph_by_chars(number: 251)
            find("#submit-button").click
            expect(page).to have_content "プロフィールを編集できません"
            expect(page).to have_content "プロフィールは250文字以内で入力してください"
            expect(current_path).to eq edit_user_path(user)
          end
        end
      end
      describe "ユーザーのお気に入り一覧ページにアクセス" do
        it "ユーザーがお気に入りに登録したトピックが表示される" do
          visit visited_boards_user_path(user)
          click_link "お気に入り"
          expect(page).to have_content user.liked_boards.last.title
          expect(page).to have_current_path(liked_boards_user_path(user), wait: 5)
        end
      end
      describe "ユーザーの活動一覧ページにアクセス" do
        it "ユーザーの活動に関連するトピックが表示される" do
          visit visited_boards_user_path(user)
          click_link "ユーザーの活動"
          expect(page).to have_content user.user_board_actions.last.title
          expect(page).to have_current_path(user_actions_user_path(user), wait: 5)
        end
      end
      describe "ユーザーの閲覧履歴にアクセス" do
        it "ユーザーの閲覧履歴が表示される" do
          visit liked_boards_user_path(user)
          click_link "閲覧履歴"
          expect(page).to have_content user.visited_boards.last.title
          expect(page).to have_current_path(visited_boards_user_path(user), wait: 5)
        end
      end
    end
    describe "ユーザーのユーザー情報にアクセス" do
      before do
        user.profile = "ユーザーのプロフィール"
        user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')),
        filename: 'sample_image.png',
        content_type: 'image/png')
        user.save!
      end
      before { login(user) }
      it "ユーザーのユーザー情報にアクセスできる" do
        visit show_profile_user_path(user)
        expect(page).to have_content(user.user_name)
        expect(page).to have_content(user.profile)
        expect(page).to have_selector("img[src*='sample_image.png']")
        expect(current_path).to eq show_profile_user_path(user)
      end
      it "ユーザーのユーザー情報からプロフィール編集ページへ遷移できる" do
        visit show_profile_user_path(user)
        find("#edit-profile-link").click
        expect(page).to have_current_path(edit_user_path(user), wait: 5)
      end
    end
    describe "ユーザー退会" do
      before { login(user) }
      context "規約に同意して退会する場合" do
        it "退会処理が成功する" do
          visit show_profile_user_path(user)
          check 'confirmation_1'
          check 'confirmation_2'
          expect(page).to have_button('退会する', disabled: false)
          click_button '退会する'

          expect(page).to have_content('退会が完了しました')
          expect(page).to have_selector("#google-login-button", visible: true, wait: 5)
          expect(page).to have_current_path(root_path, wait: 5) # ユーザーがログアウト済み
          expect(User.exists?(id: user.id)).to be_falsey # ユーザーが存在しないことを確認
        end
      end

      context "規約に同意しない場合" do
        it "退会ボタンが有効にならない" do
          visit show_profile_user_path(user)
          expect(page).to have_button('退会する', disabled: true) # チェックボックスが未選択の場合、無効

          expect(User.exists?(id: user.id)).to be_truthy # ユーザーがまだ存在していることを確認
        end
      end
    end
  end
end
