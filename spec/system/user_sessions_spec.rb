require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  let!(:security_question) { create(:security_question) }
  let(:user) { create(:user) }
  let(:admin_user) { create(:user, user_name: "admin_user", role: 1, security_question_id: security_question.id) }
  # GoogleAPIを用いたログインについてはOauthsControllerのテストによって替える
  describe "ログアウト" do
    before { login(user) }
    it "ログアウト後、トップ画面にリダイレクトされる" do
      page.driver.browser.manage.window.resize_to(1024, 768)
      find('#header-user-name', visible: true, wait: 10).hover
      expect(page).to have_selector('#header-logout', visible: true, wait: 5)

      find('#header-logout').click

      expect(page).to have_content("ログアウトしました")
      expect(current_path).to eq root_path
    end
  end
end
