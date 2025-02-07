# require 'rails_helper'

# RSpec.describe "AdminBoards", type: :system do
#   let!(:general_user) { create(:user) }
#   let!(:admin_user) { create(:user, user_name: "admin_user", role: 1) }
#   let!(:board) { create(:board) }
#   describe "一般ユーザーによるアクセス" do
#     describe "管理者ページへのアクセスが失敗する" do
#       before { login(general_user) }
#       it "トピック一覧ページへのアクセスが失敗する" do
#         visit admin_boards_path
#         expect(page).to have_content("権限がありません")
#         expect(current_path).to eq root_path
#       end
#       it "トピック詳細ページへのアクセスが失敗する" do
#         visit admin_board_path(board)
#         expect(page).to have_content("権限がありません")
#         expect(current_path).to eq root_path
#       end
#       it "変更履歴へのアクセスが失敗する" do
#         visit board_info_admin_board_path(board)
#         expect(page).to have_content("権限がありません")
#         expect(current_path).to eq root_path
#       end
#     end
#   end

#   describe "管理者ユーザーによるアクセス" do
#     before { login(admin_user) }
#     describe "トピック一覧ページにアクセス" do
#       it "トピック一覧にトピック情報が表示される" do
#         visit admin_boards_path
#         expect(page).to have_content(board.title)
#         expect(current_path).to eq admin_boards_path
#       end
#     end
#     describe "トピック詳細ページに各種リンクが表示されるアクセス" do
#       it "トピック詳細に各種リンクが表示される" do
#         visit admin_board_path(board)
#         expect(page).to have_content(board.title)
#         expect(page).to have_content("変更履歴")
#         expect(page).to have_content("フレーム")
#         expect(page).to have_content("コメント")
#         expect(page).to have_content("報告")
#         expect(current_path).to eq admin_board_path(board)
#       end
#       describe "変更履歴にアクセス" do
#         let!(:board_edit_log) { create(:board_log, user_id: admin_user.id, board_id: board.id, action_type: 2) }
#         it "トピックに関する変更履歴が表示される" do
#           visit admin_board_path(board)
#           click_link "変更履歴"
#           expect(page).to have_content(board_edit_log.user.user_name)
#           expect(page).to have_content("トピック")
#           expect(page).to have_content(I18n.t("enums.board_log.action_type.#{board_edit_log.action_type}"))
#           expect(page).to have_content(board_edit_log.created_at.strftime('%Y-%m-%d %H:%M:%S'))
#           expect(current_path).to eq board_info_admin_board_path(board)
#         end
#       end
#       describe "トピックの削除" do
#         it "トピックを削除できる" do
#           visit admin_board_path(board)
#           click_link "トピックを削除"
#           expect(page).to have_content("トピックを削除しました")
#           expect(current_path).to eq admin_boards_path
#           expect(Board.exists?(id: board.id)).to be_falsey
#         end
#       end
#     end
#   end
# end
