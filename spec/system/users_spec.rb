# require 'rails_helper'

# RSpec.describe "Users", type: :system do
#   let!(:security_question) { create(:security_question, question_text: "秘密の質問") }
#   let(:user) { create(:user, security_question_id: security_question.id) }
#   let!(:registered_user) { create(:user, email: "registered@email.com") }
#   describe "ユーザー作成" do
#     context "ログイン前" do
#       it "フォームの入力値が正常な場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         fill_in "user_password", with: "password"
#         fill_in "user_password_confirmation", with: "password"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"
#         puts user.id
#         expect(page).to have_content("#{user.user_name}さまがログインしました", wait: 5)
#         created_user = User.find_by(email: "new_user@email.com")
#         expect(current_path).to eq user_path(created_user)
#       end

#       it "ユーザーネームが未入力の場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: ""
#         fill_in "user_email", with: "new_user@email.com"
#         fill_in "user_password", with: "password"
#         fill_in "user_password_confirmation", with: "password"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("ユーザーネームを入力してください")

#         expect(current_path).to eq new_user_path
#       end

#       it "メールアドレスが未入力の場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: ""
#         fill_in "user_password", with: "password"
#         fill_in "user_password_confirmation", with: "password"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("メールアドレスを入力してください")

#         expect(current_path).to eq new_user_path
#       end

#       it "メールアドレスがすでに登録済みの場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: registered_user.email
#         fill_in "user_password", with: "password"
#         fill_in "user_password_confirmation", with: "password"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("メールアドレスはすでに存在します")

#         expect(current_path).to eq new_user_path
#       end

#       it "パスワードが未入力の場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         fill_in "user_password", with: ""
#         fill_in "user_password_confirmation", with: ""
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("パスワードは3文字以上で入力してください")

#         expect(current_path).to eq new_user_path
#       end
#       it "パスワード確認が未入力の場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         password = Faker::Lorem.paragraph_by_chars(number: 3)
#         fill_in "user_password", with: password
#         fill_in "user_password_confirmation", with: ""
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("パスワード確認を入力してください")
#         expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

#         expect(current_path).to eq new_user_path
#       end
#       it "パスワードが3文字未満の場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         password = "p"
#         fill_in "user_password", with: password
#         fill_in "user_password_confirmation", with: password
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"

#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("パスワードは3文字以上で入力してください")

#         expect(current_path).to eq new_user_path
#       end

#       it "パスワードとパスワード確認が一致しない場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         password = Faker::Lorem.paragraph_by_chars(number: 3)
#         fill_in "user_password", with: password
#         fill_in "user_password_confirmation", with: "misspassword"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: "回答"
#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")

#         expect(current_path).to eq new_user_path
#       end

#       it "秘密の質問の回答を入力していない場合" do
#         visit root_path
#         find("#login-button").click
#         find("#create-user-link").click

#         fill_in "user_user_name", with: "new_user"
#         fill_in "user_email", with: "new_user@email.com"
#         password = Faker::Lorem.paragraph_by_chars(number: 3)
#         fill_in "user_password", with: password
#         fill_in "user_password_confirmation", with: "misspassword"
#         select security_question.question_text, from: "user_security_question_id"
#         fill_in "user_security_answer", with: ""
#         click_button "登録"

#         expect(page).to have_content("入力に不足があります")
#         expect(page).to have_content("秘密の質問の答えを入力してください")

#         expect(current_path).to eq new_user_path
#       end

#     end
#     context "ログイン後" do
#       before { login(user) }
#       it "ボード一覧にリダイレクトする" do
#         visit new_user_path
#         expect(page).to have_content("すでにログインしています")
#         expect(current_path).to eq boards_path
#       end
#     end
#   end

#   describe "ユーザーマイページ" do
#     let!(:board) { create(:board) }
#     describe "自分以外のユーザーのマイページにアクセス" do
#       let!(:registered_user_board_log) { create(:board_log, user_id: registered_user.id, board_id: board.id, action_type: 1) }
#       let!(:registered_user_like) { create(:like, user_id: registered_user.id, board_id: board.id) }
#       let!(:registered_user_visiter_board) { create(:user_board, user_id: registered_user.id, board_id: board.id) }

#       it "ユーザーのマイページにアクセスできる" do
#         visit user_path(registered_user)
#         expect(current_path).to eq user_path(registered_user)
#       end
#       describe "ユーザープロフィールの編集" do
#         it "ユーザーのプロフィール編集リンクが表示されない" do
#           visit user_path(registered_user)
#           expect(page).not_to have_selector("#users-setting")
#         end
#         it "ユーザーのプロフィール編集ページにアクセスできない" do
#           visit edit_user_path(registered_user)
#           expect(page).to have_content "権限がありません"
#           expect(current_path).to eq user_path(registered_user)
#         end
#       end
#       it "ユーザーのユーザー情報にアクセスできない" do
#         visit show_profile_user_path(registered_user)
#         expect(page).to have_content "権限がありません"
#         expect(current_path).to eq user_path(registered_user)
#       end
#       describe "ユーザーのお気に入り一覧ページにアクセス" do
#         it "ユーザーがお気に入りに登録したボードが表示される" do
#           visit user_path(registered_user)
#           click_link "お気に入り"
#           expect(page).to have_content registered_user.liked_boards.last.title
#           expect(page).to have_current_path(liked_boards_user_path(registered_user), wait: 5)
#         end
#       end
#       describe "ユーザーの活動一覧ページにアクセス" do
#         it "ユーザーの活動に関連するボードが表示される" do
#           visit user_path(registered_user)
#           click_link "ユーザーの活動"
#           expect(page).to have_content registered_user.user_board_actions.last.title
#           expect(page).to have_current_path(user_actions_user_path(registered_user), wait: 5)
#         end
#       end
#       describe "ユーザーの閲覧履歴にアクセス" do
#         it "閲覧履歴へのリンクが表示されない" do
#           visit user_path(registered_user)
#           expect(page).not_to have_content "閲覧履歴"
#           expect(current_path).to eq user_path(registered_user)
#         end
#         it "閲覧履歴にアクセスできない" do
#           visit visited_boards_user_path(registered_user)
#           expect(page).not_to have_content("権限がありません", wait: 5)
#           expect(current_path).to eq user_path(registered_user)
#         end
#       end
#     end
#     describe "自分のマイページにアクセス" do
#       let!(:user_board_log) { create(:board_log, user_id: user.id, board_id: board.id, action_type: 1) }
#       let!(:user_like) { create(:like, user_id: user.id, board_id: board.id) }
#       let!(:user_visiter_board) { create(:user_board, user_id: user.id, board_id: board.id) }
#       before { login(user) }

#       it "ユーザーのマイページにアクセスできる" do
#         visit user_path(user)
#         expect(current_path).to eq user_path(user)
#       end
#       describe "ユーザープロフィールの編集" do
#         context "入力内容が正常な場合" do
#           it "プロフィールが編集できる" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
#             fill_in "user-name", with: "編集したユーザー名"
#             fill_in "user_profile", with: "編集したプロフィール"
#             find("#submit-button").click
#             expect(page).to have_content "プロフィールを編集しました"
#             expect(page).to have_content("編集したユーザー名")
#             expect(page).to have_content("編集したプロフィール")
#             expect(page).to have_selector("img[src*='sample_image.png']")
#             expect(current_path).to eq user_path(user)
#           end
#         end
#         context "200KBを超えるファイルをアップロードした場合" do
#           it "プロフィールの編集が失敗する" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/over_size.png"))
#             fill_in "user-name", with: "編集したユーザー名"
#             fill_in "user_profile", with: "編集したプロフィール"
#             find("#submit-button").click
#             expect(page).to have_content "プロフィールを編集できません"
#             expect(page).to have_content "200KB以下のファイルをアップロードしてください"
#             expect(current_path).to eq edit_user_path(user)
#           end
#         end
#         context "ファイル形式が、JPEG, JPG, PNG以外の場合" do
#           it "プロフィールの編集が失敗する" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/webp_test.webp"))
#             fill_in "user-name", with: "編集したユーザー名"
#             fill_in "user_profile", with: "編集したプロフィール"
#             find("#submit-button").click
#             expect(page).to have_content "プロフィールを編集できません"
#             expect(page).to have_content "ファイル形式が、JPEG, JPG, PNG以外になっています"
#             expect(current_path).to eq edit_user_path(user)
#           end
#         end
#         context "ユーザー名が空の場合" do
#           it "プロフィールの編集が失敗する" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
#             fill_in "user-name", with: ""
#             fill_in "user_profile", with: "編集したプロフィール"
#             expect(find("#submit-button")[:disabled]).to eq "true" # 空の場合、作成ボタンを押下できない
#             expect(current_path).to eq edit_user_path(user)
#           end
#         end
#         context "ユーザー名の入力が20文字を超える場合" do
#           it "プロフィールの編集が失敗する" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
#             fill_in "user-name", with: Faker::Lorem.paragraph_by_chars(number: 21)
#             fill_in "user_profile", with: "編集したプロフィール"
#             find("#submit-button").click
#             expect(page).to have_content "プロフィールを編集できません"
#             expect(page).to have_content "ユーザーネームは20文字以内で入力してください"
#             expect(current_path).to eq edit_user_path(user)
#           end
#         end
#         context "プロフィールの入力が250文字を超える場合" do
#           it "プロフィールの編集が失敗する" do
#             visit user_path(user)
#             find("#users-setting").click
#             attach_file("avatar-image", Rails.root.join("spec/fixtures/files/sample_image.png"))
#             fill_in "user-name", with: "編集したユーザー名"
#             fill_in "user_profile", with: Faker::Lorem.paragraph_by_chars(number: 251)
#             find("#submit-button").click
#             expect(page).to have_content "プロフィールを編集できません"
#             expect(page).to have_content "プロフィールは250文字以内で入力してください"
#             expect(current_path).to eq edit_user_path(user)
#           end
#         end
#       end
#       describe "ユーザーのお気に入り一覧ページにアクセス" do
#         it "ユーザーがお気に入りに登録したボードが表示される" do
#           visit user_path(user)
#           click_link "お気に入り"
#           expect(page).to have_content user.liked_boards.last.title
#           expect(page).to have_current_path(liked_boards_user_path(user), wait: 5)
#         end
#       end
#       describe "ユーザーの活動一覧ページにアクセス" do
#         it "ユーザーの活動に関連するボードが表示される" do
#           visit user_path(user)
#           click_link "ユーザーの活動"
#           expect(page).to have_content user.user_board_actions.last.title
#           expect(page).to have_current_path(user_actions_user_path(user), wait: 5)
#         end
#       end
#       describe "ユーザーの閲覧履歴にアクセス" do
#         it "ユーザーの閲覧履歴が表示される" do
#           visit user_path(user)
#           click_link "閲覧履歴"
#           expect(page).to have_content user.visited_boards.last.title
#           expect(page).to have_current_path(visited_boards_user_path(user), wait: 5)
#         end
#       end
#     end
#     describe "ユーザーのユーザー情報にアクセス" do
#       before do
#         user.profile = "ユーザーのプロフィール"
#         user.avatar_image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')),
#         filename: 'sample_image.png',
#         content_type: 'image/png')
#         user.save!
#       end
#       before { login(user) }
#       it "ユーザーのユーザー情報にアクセスできる" do
#         visit show_profile_user_path(user)
#         expect(page).to have_content(user.user_name)
#         expect(page).to have_content(user.profile)
#         expect(page).to have_selector("img[src*='sample_image.png']")
#         expect(current_path).to eq show_profile_user_path(user)
#       end
#       it "ユーザーのユーザー情報からプロフィール編集ページへ遷移できる" do
#         visit show_profile_user_path(user)
#         find("#edit-profile-link").click
#         expect(page).to have_current_path(edit_user_path(user), wait: 5)
#       end
#     end
#     describe "ユーザー退会" do
#       before { login(user) }
#       context "規約に同意して退会する場合" do
#         it "退会処理が成功する" do
#           visit show_profile_user_path(user)
#           check 'confirmation_1'
#           check 'confirmation_2'
#           expect(page).to have_button('退会する', disabled: false)
#           click_button '退会する'

#           expect(page).to have_content('退会が完了しました')
#           expect(page).to have_content('ログイン')
#           expect(page).to have_current_path(root_path, wait: 5) # ユーザーがログアウト済み
#           expect(User.exists?(id: user.id)).to be_falsey # ユーザーが存在しないことを確認
#         end
#       end

#       context "規約に同意しない場合" do
#         it "退会ボタンが有効にならない" do
#           visit show_profile_user_path(user)
#           expect(page).to have_button('退会する', disabled: true) # チェックボックスが未選択の場合、無効

#           expect(User.exists?(id: user.id)).to be_truthy # ユーザーがまだ存在していることを確認
#         end
#       end
#     end
#   end
# end
