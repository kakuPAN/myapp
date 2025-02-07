# require 'rails_helper'

# RSpec.describe "Reports", type: :system do
#   let!(:commented_user) { create(:user) }
#   let!(:user) { create(:user) }
#   let!(:board) { create(:board) }
#   let!(:comment) { create(:comment, board_id: board.id, user_id: commented_user.id) }
#   let!(:board_report) { create(:report, body: "トピックの報告", board_id: board.id, user_id: user.id, comment_id: nil) }
#   let!(:comment_report) { create(:report, body: "コメントの報告", board_id: board.id, user_id: user.id, comment_id: comment.id) }

#   describe "ログイン前" do
#     describe "ページ遷移確認" do
#       describe "報告作成ページにアクセス" do
#         context "トピックの報告ボタンを押した場合" do
#           it "ログインを促すタブを表示" do
#             visit board_path(board)
#             find(".report-button").click
#             expect(page).to have_content("ログイン")
#             expect(page).to have_content("ユーザー登録")
#             expect(current_path).to eq board_path(board)
#           end
#         end
#         context "トピック報告作成ページに直接アクセスした場合" do
#           it "ログインページにリダイレクト" do
#             visit new_board_report_report_path(board, board_id: board.id)
#             expect(page).to have_content("ログインしてください")
#             expect(current_path).to eq login_path
#           end
#         end
#         context "コメント報告ページに直接アクセスした場合" do
#           it "ログインページにリダイレクト" do
#             visit new_comment_report_report_path(board, comment_id: comment.id)
#             expect(page).to have_content("ログインしてください")
#             expect(current_path).to eq login_path
#           end
#         end
#       end
#     end
#   end

#   describe "ログイン後" do
#     before { login(user) }
#     describe "報告の作成" do
#       describe "トピックの報告の作成" do
#         context "入力内容が正常な場合" do
#           it "報告の作成が成功する" do
#             visit board_path(board)
#             find(".report-button").click
#             fill_in "report_body", with: "トピックの報告"
#             click_button "送信"
#             expect(page).to have_content("報告しました")
#             expect(current_path).to eq board_path(board)
#           end
#         end
#         context "入力が空の場合" do
#           it "送信ボタンを押下できない" do
#             visit board_path(board)
#             find(".report-button").click
#             fill_in "report_body", with: ""
#             expect(find("#report-submit-button")[:disabled]).to eq "true"
#             expect(current_url).to include new_board_report_report_path(board)
#             expect(current_url).to include "board_id=#{board.id}"
#           end
#         end
#         context "入力が500文字を超える場合" do
#           it "報告の作成が失敗する" do
#             visit board_path(board)
#             find(".report-button").click
#             fill_in "report_body", with: Faker::Lorem.paragraph_by_chars(number: 501)
#             click_button "送信"
#             expect(page).to have_content("報告理由は500文字以内で入力してください", wait: 5)
#             expect(page).to have_content "報告を作成できません"
#             expect(current_url).to include new_board_report_report_path(board)
#             expect(current_url).to include "board_id=#{board.id}"
#           end
#         end
#       end
#       describe "コメントの報告の作成" do
#         context "入力内容が正常な場合" do
#           it "報告の作成が成功する" do
#             visit board_comments_path(board)
#             find("#comment-report-link-#{comment.id}").click
#             fill_in "report_body", with: "トピックの報告"
#             click_button "送信"
#             expect(page).to have_content("報告しました")
#             expect(current_path).to eq board_comments_path(board)
#           end
#         end
#         context "入力が空の場合" do
#           it "送信ボタンを押下できない" do
#             visit board_comments_path(board)
#             find("#comment-report-link-#{comment.id}").click
#             fill_in "report_body", with: ""
#             expect(find("#report-submit-button")[:disabled]).to eq "true"
#             expect(current_url).to include new_comment_report_report_path(board)
#             expect(current_url).to include "comment_id=#{comment.id}"
#           end
#         end
#         context "入力が500文字を超える場合" do
#           it "報告の作成が失敗する" do
#             visit board_comments_path(board)
#             find("#comment-report-link-#{comment.id}").click
#             fill_in "report_body", with: Faker::Lorem.paragraph_by_chars(number: 501)
#             click_button "送信"
#             expect(page).to have_content("報告理由は500文字以内で入力してください", wait: 5)
#             expect(page).to have_content "報告を作成できません"
#             expect(current_url).to include new_comment_report_report_path(board)
#             expect(current_url).to include "comment_id=#{comment.id}"
#           end
#         end
#       end
#     end
#   end
# end
