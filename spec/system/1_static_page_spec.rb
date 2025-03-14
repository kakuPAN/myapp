require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "ページ遷移確認" do
    describe "フッターのリンクからページ遷移できる" do
      before do
        page.driver.browser.manage.window.resize_to(1400, 900)
      end
      it "利用規約にアクセスできる" do
        visit root_path
        new_window = window_opened_by { find("#terms-of-service-link").click  } # 別のタブを開く
        within_window new_window do
          page.driver.browser.manage.window.resize_to(900, 500)
          expect(page).to have_content("利用規約")
          expect(current_path).to eq terms_of_service_path
        end
        new_window.close
      end
      it "プライバシーポリシーにアクセスできる" do
        visit root_path
        new_window = window_opened_by { find("#privacy-policy-link").click  }
        within_window new_window do
          expect(page).to have_content("プライバシーポリシー")
          expect(current_path).to eq privacy_policy_path
        end
        new_window.close
      end
      it "お問い合わせページ（Google Forms）にアクセスできる" do
        visit root_path
        new_window = window_opened_by { find("#contact-form-link").click }
        within_window new_window do
          expect(page).to have_content("お問い合わせ")
          expect(current_url).to include("docs.google.com/forms/d/e/1FAIpQLScyWfOx1ezyRz_1TFlh-1Wk5AGrRsgfAYAsu9rCogQTzfLwsA/viewform")
        end
        new_window.close
      end
    end
  end
  describe "ヘッダー・フッターのレスポンシブ対応" do
    let(:user) { create(:user, :with_google) }
    before { login(user) }
    context "ウィンドウサイズが1201px以上の場合" do
      before do
        page.driver.browser.manage.window.resize_to(1201, 768) # 大サイズ
      end
      it "ヘッダーにロゴ、ユーザー名が表示される" do
        visit visited_boards_user_path(user)
        expect(page).to have_selector('.logo', visible: true, wait: 5)
        expect(page).to have_selector('#header-user-name', visible: true, wait: 5)
      end
      it "サブフッターが表示されない" do
        visit visited_boards_user_path(user)
        expect(page).not_to have_selector('.sub-footer-content', visible: true, wait: 10)
      end
    end
    context "ウィンドウサイズが1200px以下の場合" do
      before do
        page.driver.browser.manage.window.resize_to(1200, 768) # 小サイズ
      end
      it "ヘッダーにロゴ、ユーザー名が表示されない" do
        visit visited_boards_user_path(user)
        expect(page).not_to have_selector('.logo', visible: true, wait: 5)
        expect(page).not_to have_selector('#header-user-name', visible: true, wait: 5)
      end
      it "サブフッターにロゴ、ユーザー名が表示される" do
        visit visited_boards_user_path(user)
        expect(page).to have_selector('.sub-footer-content', visible: true, wait: 5)
        expect(page).to have_selector('#sub-footer-icon', visible: true, wait: 5)
        expect(page).to have_selector('#sub-footer-logo', visible: true, wait: 5)
      end
    end
  end
end
