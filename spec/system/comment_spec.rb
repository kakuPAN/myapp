require "rails_helper"

RSpec.describe "Comments", type: :system do
  let!(:security_question) { create(:security_question) }
  let(:user) { create(:user) }
  let!(:board) { create(:board) }
  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "コメント一覧ページにアクセス" do
        it "コメント一覧ページにアクセスできる" do
          visit board_path(board)
          find("#comment-count").click
          expect(page).to have_current_path(board_comments_path(board), wait: 5)
        end
      end
    end
    describe "コメントの作成" do
      context "ボード詳細ページでコメントを作成" do
        it "コメントの作成ができない" do
          visit board_path(board)
          find(".comment-button").click
          expect(page).to have_content("ログイン")
          expect(page).to have_content("ユーザー登録")
          expect(current_path).to eq board_path(board)
        end
      end
      context "コメント一覧ページでコメントを作成" do
        it "コメントの作成ができない" do
          visit board_comments_path(board)
          find("#comment-form").click
          form = find("#comment-form")
          expect(form[:class]).to include("disabled")
          expect(page).to have_content("ログイン")
          expect(page).to have_content("ユーザー登録")
          expect(current_path).to eq board_comments_path(board)
        end
      end
    end
  end
  describe "ログイン後" do
    before { login(user) }
    describe "ページ遷移確認" do
      context "コメント一覧ページにアクセス" do
        it "コメント一覧ページにアクセスできる" do
          visit board_path(board)
          find("#comment-count").click
          expect(page).to have_current_path(board_comments_path(board), wait: 5)
        end
      end
    end
    describe "コメントの作成" do
      let!(:to_comment) { create(:comment, board_id: board.id) }
      describe "ボード詳細ページでコメントを作成" do
        context "入力内容が正常な場合" do
          it "コメントを作成できる" do
            visit board_path(board)
            find(".comment-button").click
            fill_in "comment_body", with: "新しいコメント"
            click_button "コメントを送信"
            expect(page).to have_selector('div.comment-text p', text: "新しいコメント", visible: :all) # 暗転背景の下にあっても検知
            expect(page).to have_content("コメントを作成しました")
            expect(current_path).to eq board_path(board)
          end
        end
        context "入力が100文字を超える場合" do
          it "コメントの作成が失敗する" do
            visit board_path(board)
            find(".comment-button").click
            body = Faker::Lorem.paragraph_by_chars(number: 101)
            fill_in "comment_body", with: body
            click_button "コメントを送信"
            expect(page).to have_content("コメントを作成できません")
            expect(current_path).to eq board_path(board)
          end
        end
      end
      describe "コメント一覧ページでコメントを作成" do
        context "入力内容が正常な場合" do
          it "コメントを作成できる" do
            visit board_comments_path(board)
            fill_in "comment_body", with: "新しいコメント"
            find("#comments-comment-submit").click
            expect(page).to have_content("新しいコメント")
            expect(page).to have_content("コメントを作成しました")
            expect(current_path).to eq board_comments_path(board)
          end
          it "コメントに返信できる" do
            visit board_comments_path(board)
            find("#to-comment-#{to_comment.id}").click
            fill_in "reply-textarea-#{to_comment.id}", with: "新しい返信"
            find("#reply-submit-#{to_comment.id}").click
            expect(page).to have_content("新しい返信")
            expect(page).to have_content("コメントを作成しました")
            expect(current_path).to eq board_comments_path(board)
          end
        end
        context "入力が100文字を超える場合" do
          it "コメントの作成が失敗する" do
            visit board_comments_path(board)
            body = Faker::Lorem.paragraph_by_chars(number: 101)
            fill_in "comment_body", with: body
            find("#comments-comment-submit").click
            expect(page).to have_content("コメントを作成できません")
            expect(current_path).to eq board_comments_path(board)
          end
          it "返信コメントの作成が失敗する" do
            visit board_comments_path(board)
            find("#to-comment-#{to_comment.id}").click
            body = Faker::Lorem.paragraph_by_chars(number: 101)
            fill_in "reply-textarea-#{to_comment.id}", with: body
            find("#reply-submit-#{to_comment.id}").click
            expect(page).to have_content("コメントを作成できません")
            expect(current_path).to eq board_comments_path(board)
          end
        end
      end
    end
    describe "コメントの編集" do
      let!(:to_comment) { create(:comment, user_id: user.id, board_id: board.id) }
      let!(:reply) { create(:comment, user_id: user.id, board_id: board.id, parent_id: to_comment.id) }
      describe "ボード詳細ページでコメントを編集" do
        context "入力内容が正常な場合" do
          it "コメントを編集できる" do
            visit board_comments_path(board)
            find("#edit-comment-button-#{to_comment.id}").click
            expect(page).to have_content("#{to_comment.body}")
            fill_in "comment_body_#{to_comment.id}", with: "編集したコメント"
            expect(page).to have_field("comment_body_#{to_comment.id}", with: "編集したコメント", wait: 5)
            expect(page).to have_selector("#edit_comment_submit_#{to_comment.id}:not([disabled])", wait: 10)
            find("#edit_comment_submit_#{to_comment.id}").click
            expect(page).to have_content("編集したコメント")
            expect(page).to have_content("コメントを編集しました")
            expect(to_comment.reload.body).to eq "編集したコメント"
            expect(current_path).to eq board_comments_path(board)
          end
        end
        context "入力が100文字を超える場合" do
          it "コメントの作成が失敗する" do
            visit board_comments_path(board)
            find("#edit-comment-button-#{to_comment.id}").click
            expect(page).to have_content("#{to_comment.body}")
            body = Faker::Lorem.paragraph_by_chars(number: 101)
            fill_in "comment_body_#{to_comment.id}", with: body
            find("#edit_comment_submit_#{to_comment.id}").click
            expect(page).to have_content("コメントを編集できません")
            expect(current_path).to eq board_comments_path(board)
          end
          it "コメント返信の作成が失敗する" do
            visit board_comments_path(board)
            find("#edit-comment-button-#{reply.id}").click
            expect(page).to have_content("#{reply.body}")
            body = Faker::Lorem.paragraph_by_chars(number: 101)
            fill_in "comment_body_#{reply.id}", with: body
            find("#edit_comment_submit_#{reply.id}").click
            expect(page).to have_content("コメントを編集できません")
            expect(current_path).to eq board_comments_path(board)
          end
        end
      end
    end
    describe "コメントの削除" do
      let!(:to_comment) { create(:comment, user_id: user.id, board_id: board.id) }
      let!(:reply) { create(:comment, user_id: user.id, board_id: board.id, parent_id: to_comment.id) }
      describe "コメント一覧ページでコメントを削除" do
        it "コメントを削除できる" do
          visit board_comments_path(board)
          find("#delete-comment-button-#{to_comment.id}").click
          expect(page).not_to have_content(to_comment.body)
          expect(page).to have_content("コメントを削除しました")
        end
        it "返信コメントを削除できる" do
          visit board_comments_path(board)
          find("#delete-comment-button-#{reply.id}").click
          expect(page).not_to have_content(reply.body)
          expect(page).to have_content("コメントを削除しました")
        end
      end
    end
  end
end
