require 'rails_helper'

RSpec.describe "AdminFrames", type: :system do
  let!(:general_user) { create(:user, :with_google) }
  let!(:admin_user) { create(:user, :with_google, :admin) }
  let!(:board) { create(:board) }
  let!(:frame) { create(:frame, board_id: board.id) }
  describe "ログインしていないユーザーによるアクセス" do
    describe "管理者ページへのアクセスが失敗する" do
      it "フレーム一覧ページへのアクセスが失敗する" do
        visit admin_board_frames_path(board)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
      it "フレーム詳細ページへのアクセスが失敗する" do
        visit admin_board_frame_path(board, frame)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
    end
  end

  describe "一般ユーザーによるアクセス" do
    describe "管理者ページへのアクセスが失敗する" do
      before { login(general_user) }
      it "フレーム一覧ページへのアクセスが失敗する" do
        visit admin_board_frames_path(board)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
      it "フレーム詳細ページへのアクセスが失敗する" do
        visit admin_board_frame_path(board, frame)
        expect(page).to have_content("権限がありません")
        expect(current_path).to eq root_path
      end
    end
  end

  describe "管理者ユーザーによるアクセス" do
    before { login(admin_user) }
    describe "フレーム一覧ページにアクセス" do
      let!(:frame_log) { create(:board_log, user_id: admin_user.id, board_id: board.id, frame_id: frame.id, action_type: 1) }
      it "フレーム一覧にフレーム情報が表示される" do
        visit admin_board_path(board)
        click_link "フレーム"
        expect(page).to have_content(frame.frame_number)
        expect(page).to have_content(I18n.t("enums.frame.frame_type.#{frame.frame_type}"))
        expect(page).to have_content(I18n.t("enums.board_log.action_type.#{frame_log.action_type}"))
        expect(page).to have_content(frame_log.user.user_name)
        expect(page).to have_content(frame.updated_at.strftime('%Y-%m-%d %H:%M:%S'))
        visit admin_board_frames_path(board)
      end
    end
    describe "フレーム詳細ページにアクセス" do
      context "テキストフレームの場合" do
        it "フレーム詳細にフレームの詳細情報が表示される" do
          visit admin_board_path(board)
          click_link "フレーム"
          find("#frame-link-#{frame.id}").click
          expect(page).to have_content(frame.content.body.to_plain_text)
          visit admin_board_frame_path(board, frame)
        end
      end
      context "画像フレームの場合" do
        let(:image_frame) do
          Frame.new(board_id: board.id, content: nil, frame_type: 1)
        end
        before do
          image_frame.frame_number = Frame.where(board_id: board.id).order(frame_number: :desc).first&.frame_number + 1
          image_frame.image.attach(io: File.open(Rails.root.join('spec/fixtures/files/sample_image.png')),
          filename: 'sample_image.png',
          content_type: 'image/png')
          image_frame.save!
        end
        it "フレーム詳細にフレームの詳細情報が表示される" do
          visit admin_board_path(board)
          click_link "フレーム"
          find("#frame-link-#{image_frame.id}").click
          expect(page).to have_selector("img[src*='sample_image.png']", wait: 5)
          visit admin_board_frame_path(board, image_frame)
        end
      end
      describe "フレームの削除" do
        it "フレームを削除できる" do
          visit admin_board_path(board)
          click_link "フレーム"
          find("#frame-link-#{frame.id}").click
          find("#delete-frame-button").click
          expect(page).to have_content("フレームを削除しました")
          visit admin_board_frames_path(board)
          expect(Frame.exists?(id: frame.id)).to be_falsey
        end
      end
    end
  end
end
