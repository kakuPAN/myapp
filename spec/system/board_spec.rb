require "rails_helper"

RSpec.describe "Boards", type: :system do
  let(:user) { create(:user, :with_google) }
  let(:board) { create(:board) }
  let!(:latest_board) { create(:board) }
  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "トピックの作成ページにアクセス" do
        it "作成ページへのアクセスが失敗する" do
          visit new_board_path
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq root_path
        end
      end

      context "トピックの編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          visit edit_board_path(board)
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq root_path
        end
      end

      context "トピックの詳細ページにアクセス" do
        it "トピックの詳細情報が表示される" do
          visit board_path(board)
          expect(page).to have_content board.title
          expect(current_path).to eq board_path(board)
        end
      end

      context "トピックの一覧ページにアクセス" do
        it "最新のトピックが表示される" do
          visit boards_path
          expect(page).to have_content latest_board.title

          expect(current_path).to eq boards_path
        end
      end
    end
  end

  describe "ログイン後" do
   before { login(user) }
    describe "トピック作成" do
      context "フォームの入力値が正常な場合" do
        it "トピックの作成が成功する" do
          visit board_path(board)
          find('#create-new-board').click
          fill_in "board_title", with: "test_title"
          find("#create-new-board").click
          expect(page).to have_content("test_title", wait: 5)
          # 新しいトピックが確実に作成されたことを確認
          last_board_id = Board.last.id
          expect(page).to have_current_path("/boards/#{last_board_id}/edit", wait: 5)
        end
      end
      context "タイトルが未入力の場合" do
        it "作成ボタンを押下できない" do
          visit board_path(board)
          find('#create-new-board').click

          fill_in "board_title", with: ""
          expect(find("#create-new-board")[:disabled]).to eq "true" # 空の場合、作成ボタンを押下できない
          expect(current_path).to eq new_board_path
        end
      end
      context "タイトルが100文字以上の場合" do
        it "トピックの作成が失敗する" do
          visit board_path(board)
          find('#create-new-board').click

          fill_in "board_title", with: Faker::Lorem.paragraph_by_chars(number: 101)
          find("#create-new-board").click

          expect(page).to have_content "入力に不足があります"
          expect(page).to have_content "タイトルは100文字以内で入力してください"

          expect(current_path).to eq new_board_path
        end
      end
    end

    describe "トピック編集" do
      let!(:board) { create(:board, title: "元のタイトル") }
      before { visit edit_board_path(board) }

      context "フォームの入力値が正常な場合" do
        it "トピックの編集が成功する" do
          visit edit_board_path(board)

          find('#edit-board-link').click
          expect(page).to have_selector('#edit-form', visible: true, wait: 5)

          fill_in "title-text", with: "変更後のタイトル"
          find("#create-new-board").click

          expect(page).to have_content "変更後のタイトル"
          expect(page).to have_content "タイトルを変更しました"

          expect(current_path).to eq edit_board_path(board)
        end
      end

      context "タイトルが未入力の場合" do
        it "トピックの編集ができない" do
          visit edit_board_path(board)

          find('#edit-board-link').click
          expect(page).to have_selector('#edit-form', visible: true, wait: 5)

          fill_in "title-text", with: ""
          expect(find("#create-new-board")[:disabled]).to eq "true" # 空の場合、作成ボタンを押下できない

          expect(current_path).to eq edit_board_path(board)
        end
      end

      context "タイトルが100文字以上の場合" do
        it "トピックの編集が失敗する" do
          visit edit_board_path(board)

          find('#edit-board-link').click
          expect(page).to have_selector('#edit-form', visible: true, wait: 5)

          fill_in "title-text", with: Faker::Lorem.paragraph_by_chars(number: 101)
          find("#create-new-board").click

          expect(page).to have_content "タイトルは100文字以内で入力してください"
          expect(page).to have_content "タイトルを変更できません"

          expect(current_path).to eq edit_board_path(board)
        end
      end
    end

    describe "トピックの報告" do
      let!(:board) { create(:board) }
      it "報告作成ページに遷移できる" do
        visit edit_board_path(board)
        find("#delete-board-button").click
        expect(page).to have_content("トピックの問題を報告", wait: 5)
        expect(current_url).to include(new_board_report_report_path(board))
        expect(current_url).to include "board_id=#{board.id}"
      end
    end
  end
  describe "トピックの検索" do
    let!(:searchable_board) { create(:board, title: "一致したトピック") }
    let!(:not_searchable_board) { create(:board, title: "一致しないトピック") }
    context "検索フォームに部分一致するタイトルを入力した場合" do
      it "部分一致するトピックだけが表示される" do
        visit boards_path
        fill_in "search-field", with: "一致した"
        click_button "検索"
        expect(page).to have_css(".index-board-title a", text: searchable_board.title, wait: 5)
        expect(page).not_to have_css(".index-board-title a", text: not_searchable_board.title, wait: 5)
        expect(current_path).to eq boards_path
      end
    end
    context "検索フォームに部分一致しないタイトルを入力した場合" do
      it "トピックが表示されない" do
        visit boards_path
        fill_in "search-field", with: "存在しないタイトル"
        click_button "検索"
        expect(page).not_to have_css(".index-board-title a", text: searchable_board.title, wait: 5)
        expect(page).not_to have_css(".index-board-title a", text: not_searchable_board.title, wait: 5)
        expect(page).to have_content("該当するトピックが見つかりません")
        expect(current_path).to eq boards_path
      end
    end
  end
end
