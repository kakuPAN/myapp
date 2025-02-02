require 'rails_helper'

RSpec.describe "AdminFrames", type: :system do
  let!(:security_question) { create(:security_question, question_text: "秘密の質問") }
  let!(:general_user) { create(:user, security_question_id: security_question.id) }
  let!(:admin_user) { create(:user, user_name: "admin_user", role: 1, security_question_id: security_question.id) }
  let!(:board) { create(:board) }
  let!(:comment) { create(:comment, board_id: board.id, user_id: admin_user.id) }
  let!(:reply) { create(:comment, board_id: board.id, user_id: admin_user.id, parent_id: comment.id) }
  describe "一般ユーザーによるアクセス" do
    describe "管理者ページへのアクセスが失敗する" do
      before { login(general_user) }
      it "コメント一覧ページへのアクセスが失敗する" do
        visit admin_board_comments_path(board)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
      it "コメント詳細ページへのアクセスが失敗する" do
        visit admin_board_comment_path(board, comment)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
    end
  end

  describe "管理者ユーザーによるアクセス" do
    before { login(admin_user) }
    describe "コメント一覧ページにアクセス" do
      it "コメント一覧にコメント情報が表示される" do
        visit admin_board_path(board)
        click_link "コメント"
        expect(page).to have_content(comment.body)
        expect(current_path).to eq admin_board_comments_path(board)
      end
    end
    describe "コメント詳細ページにアクセス" do
      it "コメント詳細にコメント・返信コメントの詳細情報が表示される" do
        visit admin_board_path(board)
        click_link "コメント"
        find("#comment-link-#{comment.id}").click
        comments = [ comment, reply ]
        comments.each do |content|
          expect(page).to have_content(content.id)
          expect(page).to have_content(content.user.user_name)
          expect(page).to have_content(content.body)
          expect(page).to have_content(content.updated_at.strftime('%Y-%m-%d %H:%M:%S'))
        end
        expect(current_path).to eq admin_board_comment_path(board, comment)
      end
      describe "コメントの削除" do
        it "コメントの削除ができる" do
          visit admin_board_path(board)
          click_link "コメント"
          find("#comment-link-#{comment.id}").click
          find("#delete-comment").click
          expect(page).to have_content("コメントを削除しました")
          expect(current_path).to eq admin_board_comments_path(board)
        end
      end
    end
  end
end
