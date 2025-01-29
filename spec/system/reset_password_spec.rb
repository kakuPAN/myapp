# require "rails_helper"

# RSpec.describe "ResetPassword", type: :system do
#   let!(:security_question) { create(:security_question) }
#   let(:user) { create(:user) }
#   describe "ログイン前" do
#     describe "ページ遷移確認" do
#       context "パスワードリセット申請ページにアクセス" do
#         it "アクセスが成功する" do
#           visit root_path
#           find("#login-button").click
#           find("#forget-password-link").click
#           expect(page).to have_current_path(new_password_reset_path, wait: 5)
#         end
#       end
#     end
#     describe "パスワードリセット" do
#       describe "パスワードリセットが成功" do
#         context "入力内容が全て正しい場合" do
#           it "パスワードリセットができる" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "#{new_user.email}"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"

#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             fill_in "user_password", with: "new_pass"
#             fill_in "user_password_confirmation", with: "new_pass"
#             click_button("パスワードをリセット") # 新しいパスワードを設定

#             expect(page).to have_content("パスワードをリセットしました")

#             expect(current_path).to eq login_path

#             fill_in "session-email", with: new_user.email
#             fill_in "session-password", with: "new_pass"
#             find('#login-submit').click
#             expect(page).to have_content("#{new_user.user_name}さまがログインしました")
#             expect(current_path).to eq user_path(new_user) # 新しいパスワードでログインできることを確認
#           end
#         end
#         context "パスワードリセット後、元のパスワードでログインした場合" do
#           it "ログインが失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "#{new_user.email}"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"

#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             fill_in "user_password", with: "new_pass"
#             fill_in "user_password_confirmation", with: "new_pass"
#             click_button("パスワードをリセット") # 新しいパスワードを設定

#             expect(page).to have_content("パスワードをリセットしました")

#             expect(current_path).to eq login_path

#             fill_in "session-email", with: new_user.email
#             fill_in "session-password", with: "password"
#             find('#login-submit').click

#             expect(page).to have_content("ユーザーが存在しません")
#             expect(current_path).to eq login_path
#           end
#         end
#       end
#       describe "パスワードリセット申請が失敗" do
#         context "メールアドレスが存在しない場合" do
#           it "パスワードリセット申請が失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "miss@email.com"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"
#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             expect(page).to have_content("入力内容に誤りがあります")
#             expect(current_path).to eq new_password_reset_path
#           end
#         end
#         context "秘密の質問が間違っている場合" do
#           it "パスワードリセット申請が失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: new_user.email
#             select security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"
#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             expect(page).to have_content("入力内容に誤りがあります")
#             expect(current_path).to eq new_password_reset_path
#           end
#         end
#         context "秘密の質問の回答が間違っている場合" do
#           it "パスワードリセット申請が失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: new_user.email
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "間違った回答"
#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             expect(page).to have_content("入力内容に誤りがあります")
#             expect(current_path).to eq new_password_reset_path
#           end
#         end
#       end
#       describe "パスワードリセット申請後、パスワードの再設定に失敗する" do
#         context "パスワードがない場合" do
#           it "パスワードリセットが失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "#{new_user.email}"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"

#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信

#             fill_in "user_password", with: ""
#             fill_in "user_password_confirmation", with: ""
#             click_button("パスワードをリセット") # 新しいパスワードを設定

#             expect(page).to have_content("パスワードリセットに失敗しました")
#             expect(page).to have_content("パスワードは3文字以上で入力してください")
#           end
#         end
#         context "パスワードが50文字以上の場合" do
#           it "パスワードリセットが失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "#{new_user.email}"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"

#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信
#             password = Faker::Lorem.paragraph_by_chars(number: 51)
#             fill_in "user_password", with: password
#             fill_in "user_password_confirmation", with: password
#             click_button("パスワードをリセット") # 新しいパスワードを設定

#             expect(page).to have_content("パスワードリセットに失敗しました")
#             expect(page).to have_content("パスワードは50文字以内で入力してください")
#           end
#         end
#         context "パスワードとパスワード確認が一致しない場合" do
#           it "パスワードリセットが失敗する" do
#             new_security_question = create(:security_question, question_text: "新しい質問")
#             new_user = create(:user, security_question_id: new_security_question.id, security_answer_digest: BCrypt::Password.create("回答"))
#             visit new_password_reset_path

#             fill_in "email", with: "#{new_user.email}"
#             select new_user.security_question.question_text, from: "security_question_id"
#             fill_in "security_answer", with: "回答"

#             find("#security-question-submit").click # 秘密の質問に回答し、リセット申請を送信
#             password = Faker::Lorem.paragraph_by_chars(number: 5)
#             fill_in "user_password", with: password
#             fill_in "user_password_confirmation", with: "misspassword"
#             click_button("パスワードをリセット") # 新しいパスワードを設定

#             expect(page).to have_content("パスワードリセットに失敗しました")
#             expect(page).to have_content("パスワード確認とパスワードの入力が一致しません")
#           end
#         end
#       end
#     end
#   end
#   describe "ログイン後" do
#     before { login(user) }
#     describe "ページ遷移確認" do
#       it "アクセスが失敗する" do
#         visit new_password_reset_path
#         expect(page).to have_content("すでにログインしています")
#         expect(current_path).to eq user_path(user)
#       end
#     end
#   end
# end
