# require 'rails_helper'

# RSpec.describe "AdminReports", type: :system do
#   let!(:security_question) { create(:security_question, question_text: "秘密の質問") }
#   let!(:general_user) { create(:user, security_question_id: security_question.id) }
#   let!(:admin_user) { create(:user, user_name: "admin_user", role: 1, security_question_id: security_question.id) }
#   let!(:board) { create(:board) }
#   let!(:comment) { create(:comment, board_id: board.id, user_id: admin_user.id) }
#   let!(:board_report) { create(:report, body: "トピックの報告", board_id: board.id, user_id: general_user.id, comment_id: nil) }
#   let!(:comment_report) { create(:report, body: "コメントの報告", board_id: board.id, user_id: general_user.id, comment_id: comment.id) }

#   describe "一般ユーザーによるアクセス" do
#     describe "管理者ページへのアクセスが失敗する" do
#       before { login(general_user) }
#       it "報告一覧ページへのアクセスが失敗する" do
#         visit admin_reports_path(board_id: board.id)
#         expect(page).to have_content("権限がありません")
#         expect(current_path).to eq root_path
#       end
#       it "報告詳細ページへのアクセスが失敗する" do
#         visit admin_report_path(board_report)
#         expect(page).to have_content("権限がありません")
#         expect(current_path).to eq root_path
#       end
#     end
#   end

#   describe "管理者ユーザーによるアクセス" do
#     before { login(admin_user) }
#     describe "報告一覧ページにアクセス" do
#       it "報告一覧に報告情報が表示される" do
#         visit admin_board_path(board)
#         click_link "報告"
#         reports = [ board_report, comment_report ]
#         reports.each do |report|
#           expect(page).to have_content(report.id)
#           expect(page).to have_content(report.user.user_name)
#           if report.comment
#             expect(page).to have_content("コメント")
#           else
#             expect(page).to have_content("トピック")
#           end
#           expect(page).to have_content(report.body)
#           expect(page).to have_content(report.created_at.strftime('%Y-%m-%d %H:%M:%S'))
#         end
#         expect(current_url).to include admin_reports_path
#         expect(current_url).to include "board_id=#{board.id}"
#       end
#     end
#     describe "報告詳細ページにアクセス" do
#       it "報告詳細に報告の詳細情報が表示される" do
#         visit admin_board_path(board)
#         click_link "報告"
#         find("#report-link-#{board_report.id}").click
#         expect(page).to have_content(board_report.id)
#         expect(page).to have_content(board_report.user.user_name)
#         expect(page).to have_content("トピック")
#         expect(page).to have_content(board_report.body)
#         expect(page).to have_content(board_report.created_at.strftime('%Y-%m-%d %H:%M:%S'))
#         expect(current_path).to eq admin_report_path(board_report)
#       end
#       describe "報告の削除" do
#         it "報告を削除できる" do
#           visit admin_board_path(board)
#           click_link "報告"
#           find("#report-link-#{board_report.id}").click
#           find("#delete-report-button").click
#           expect(page).to have_content("報告を削除しました")
#           expect(current_url).to include admin_reports_path
#           expect(current_url).to include "board_id=#{board.id}"
#           expect(Report.exists?(id: board_report.id)).to be_falsey
#         end
#       end
#     end
#   end
# end
