require "rails_helper"

RSpec.describe "Likes", type: :system do
  let(:user) { create(:user) }
  let(:board) { create(:board) }
  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "お気に入り登録ボタンを押す" do
        it "お気に入り登録が失敗する" do
          visit board_path(board)
          find("#like-button-not-login").click
          expect(page).to have_content("LINEでログインorユーザー登録")
          expect(current_path).to eq board_path(board)
        end
      end
    end
  end

  describe "ログイン後" do
    before { login(user) }
    context "お気に入り登録ボタンを押す" do
      it "お気に入り登録ができる" do
        visit board_path(board)
        find("#like-button-#{board.id}").click
        expect(find("#unlike-button-#{board.id}"))
        expect(page).to have_content("お気に入りに登録しました")
        expect(current_path).to eq board_path(board)
      end
    end

    context "お気に入り解除ボタンを押す" do
      let!(:board) { create(:board) }
      let!(:like) { create(:like, board_id: board.id, user_id: user.id) }
      it "お気に入り解除ができる" do
        visit board_path(board)
        find("#unlike-button-#{board.id}").click
        expect(find("#like-button-#{board.id}"))
        expect(page).to have_content("お気に入りを解除しました")
        expect(current_path).to eq board_path(board)
      end
    end
  end
end