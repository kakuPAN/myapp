require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "ページ遷移確認" do
    describe "フッターのリンクからページ遷移できる" do
      it "利用規約にアクセスできる" do
        visit root_path
        new_window = window_opened_by { click_link "利用規約" } # 別のタブを開く
        within_window new_window do
          expect(page).to have_content("利用規約")
          expect(current_path).to eq terms_of_service_path
        end
        new_window.close
      end
      it "プライバシーポリシーにアクセスできる" do
        visit root_path
        new_window = window_opened_by { click_link "プライバシーポリシー" }
        within_window new_window do
          expect(page).to have_content("プライバシーポリシー")
          expect(current_path).to eq privacy_policy_path
        end
        new_window.close
      end
      it "お問い合わせページ（Google Forms）にアクセスできる" do
        visit root_path
        new_window = window_opened_by { click_link "お問い合わせ" }
        within_window new_window do
          expect(page).to have_content("お問い合わせ")
          expect(current_url).to include("docs.google.com/forms/d/e/1FAIpQLScyWfOx1ezyRz_1TFlh-1Wk5AGrRsgfAYAsu9rCogQTzfLwsA/viewform")
        end
        new_window.close
      end
    end
  end
end
