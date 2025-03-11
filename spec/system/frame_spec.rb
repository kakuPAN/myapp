require "rails_helper"

RSpec.describe "Frames", type: :system do
  let(:user) { create(:user, :with_google) }
  let(:board) { create(:board) }
  let(:frame) { create(:frame) }
  describe "ログイン前" do
    describe "ページ遷移確認" do
      context "フレームの作成ページにアクセス" do
        it "作成ページへのアクセスが失敗する" do
          visit new_board_frame_path(board)
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq root_path
        end
      end

      context "ボードの編集ページにアクセス" do
        it "編集ページへのアクセスが失敗する" do
          visit edit_board_frame_path(board, frame)
          expect(page).to have_content("ログインしてください")
          expect(current_path).to eq root_path
        end
      end
    end
  end
  describe "ログイン後" do
    before { login(user) }
    describe "テキストフレームの作成" do
      context "フォームの入力値が正常な場合" do
        it "フレームの作成が成功する" do
          visit edit_board_path(board)
          find("#create-text-frame").click
          
          expect(page).to have_selector("trix-editor#frame_body", visible: true, wait: 5)
          
          fill_in_rich_text_area "frame_body", with: "テキスト"
          find("#frame-submit-button").click

          expect(page).to have_current_path(edit_board_path(board), wait: 5)
          expect(page).to have_content "テキスト"
        end
      end

      context "フォームの入力値が空の場合" do
        it "フレームの作成が失敗する" do
          visit edit_board_path(board)
          find("#create-text-frame").click

          fill_in_rich_text_area "frame_body", with: ""
          find("#frame-submit-button").click

          expect(page).to have_content "フレームを作成できません"
          expect(page).to have_content "本文を入力してください"
         
          expect(current_path).to eq new_board_frame_path(board)
        end
      end

      context "フォームの入力値が1000文字を超える場合" do
        it "フレームの作成が失敗する" do
          visit edit_board_path(board)
          find("#create-text-frame").click

          fill_in_rich_text_area "frame_body", with: Faker::Lorem.paragraph_by_chars(number: 1001)
          find("#frame-submit-button").click

          expect(page).to have_content "フレームを作成できません"
          expect(page).to have_content "本文は1000文字以内で入力してください"
         
          expect(current_path).to eq new_board_frame_path(board)
        end
      end
    end
    describe "画像フレームの作成" do
      # context "画像のアップロードが正常な場合" do
      #   it "フレームの作成が成功する" do
      #     visit edit_board_path(board)
      #     find("#create-image-frame").click
      #     attach_file("frame-image", Rails.root.join("spec/fixtures/files/sample_image.png"))

      #     expect(page).to have_selector("#frame-submit-button:not([disabled])", visible: true, wait: 10)
      #     find("#frame-submit-button").click

      #     expect(page).to have_current_path(edit_board_path(board), wait: 5)
      #     expect(page).to have_content "フレームが作成されました"
      #   end
      # end

      context "200KBを超えるファイルをアップロードした場合" do
        it "フレームの作成が失敗する" do
          visit edit_board_path(board)
          find("#create-image-frame").click
          attach_file("frame-image", Rails.root.join("spec/fixtures/files/over_size.png"))

          expect(page).to have_selector("#frame-submit-button:not([disabled])", visible: true, wait: 10)
          find("#frame-submit-button").click


          expect(page).to have_content("200KB以下のファイルをアップロードしてください", wait: 5)
          expect(page).to have_content "フレームを作成できません"
          expect(current_url).to include("#{new_board_frame_path(board)}?frame_type=1")
        end
      end

      context "ファイル形式が、JPEG, JPG, PNG, WEBP以外の場合" do
        it "フレームの作成が失敗する" do
          visit edit_board_path(board)
          find("#create-image-frame").click
          attach_file("frame-image", Rails.root.join("spec/fixtures/files/gif_test.gif"))

          expect(page).to have_selector("#frame-submit-button:not([disabled])", visible: true, wait: 10)
          find("#frame-submit-button").click

          expect(page).to have_content("ファイル形式が、JPEG, JPG, PNG, WEBP以外になっています", wait: 5)
          expect(page).to have_content "フレームを作成できません"
          expect(current_url).to include("#{new_board_frame_path(board)}?frame_type=1")
        end
      end
    end

    describe "フレームの削除" do
      let!(:frame) { create(:frame, board_id: board.id, frame_number: 1) }
      it "フレームの削除が成功する" do
        visit edit_board_path(board)

        find("#frame-content-#{frame.frame_number}").click
        expect(page).to have_selector("#delete-frame-link-#{frame.frame_number}", visible: true, wait: 5)
        find("#delete-frame-link-#{frame.frame_number}").click

        expect(page).to have_content "フレームを削除しました"
        expect(current_path).to eq edit_board_path(board)
      end
    end

    describe "フレームの移動" do
      let!(:first_frame) { create(:frame, board_id: board.id, content: "フレーム１", frame_number: 1) }
      let!(:second_frame) { create(:frame, board_id: board.id, content: "フレーム２", frame_number: 2) }
      describe "フレームを前に移動" do
        context "フレームが一番前ではない場合" do
          it "前後のフレームの番号が入れ替わる" do
            visit edit_board_path(board)

            find("#frame-content-#{second_frame.frame_number}").click
            expect(page).to have_selector("#move-forword-#{second_frame.frame_number}", visible: true, wait: 5)
            find("#move-forword-#{second_frame.frame_number}").click

            expect(page).to have_content "フレームを移動しました"

            expect(second_frame.reload.frame_number).to eq 1
            expect(first_frame.reload.frame_number).to eq 2

            within "#frame-content-1" do
              expect(page).to have_content second_frame.content.body.to_plain_text
            end

            within "#frame-content-2" do
              expect(page).to have_content first_frame.content.body.to_plain_text
            end
          end
        end
        context "フレームが一番前の場合" do
          it "移動することができない" do
            visit edit_board_path(board)

            find("#frame-content-#{first_frame.frame_number}").click
            expect(page).to have_selector("#move-forword-button-#{first_frame.frame_number}", visible: true, wait: 5)
            button = find("#move-forword-button-#{first_frame.frame_number}")
            expect(button[:class]).to include("disabled")

            expect(second_frame.reload.frame_number).to eq 2
            expect(first_frame.reload.frame_number).to eq 1

            within "#frame-content-1" do
              expect(page).to have_content first_frame.content.body.to_plain_text
            end

            within "#frame-content-2" do
              expect(page).to have_content second_frame.content.body.to_plain_text
            end
          end
        end
      end

      describe "フレームを後ろに移動" do
        context "フレームが一番後ろではない場合" do
          it "前後のフレームの番号が入れ替わる" do
            visit edit_board_path(board)

            find("#frame-content-#{first_frame.frame_number}").click
            expect(page).to have_selector("#move-back-#{first_frame.frame_number}", visible: true, wait: 5)
            find("#move-back-#{first_frame.frame_number}").click

            expect(page).to have_content "フレームを移動しました"

            expect(first_frame.reload.frame_number).to eq 2
            expect(second_frame.reload.frame_number).to eq 1

            within "#frame-content-1" do
              expect(page).to have_content second_frame.content.body.to_plain_text
            end

            within "#frame-content-2" do
              expect(page).to have_content first_frame.content.body.to_plain_text
            end
          end
        end

        context "フレームが一番後ろの場合" do
          it "移動することができない" do
            visit edit_board_path(board)

            find("#frame-content-#{second_frame.frame_number}").click
            expect(page).to have_selector("#move-back-button-#{second_frame.frame_number}", visible: true, wait: 5)
            button = find("#move-back-button-#{second_frame.frame_number}")
            expect(button[:class]).to include("disabled")

            expect(second_frame.reload.frame_number).to eq 2
            expect(first_frame.reload.frame_number).to eq 1

            within "#frame-content-1" do
              expect(page).to have_content first_frame.content.body.to_plain_text
            end

            within "#frame-content-2" do
              expect(page).to have_content second_frame.content.body.to_plain_text
            end
          end
        end
      end
    end
  end
end
